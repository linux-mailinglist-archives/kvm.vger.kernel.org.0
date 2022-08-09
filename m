Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAA758D760
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 12:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235132AbiHIKYR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 06:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236723AbiHIKYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 06:24:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EB21A3A2
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 03:24:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eT+psvj+4mc5ZJbpayansBmXdtF8aTIUnGseg9sT7JEl14eDbiky/Do9d7DroS8CJhHii6VXMjqHsmqnJ+Psrf6SW4H88TB4E0LdqK44NuZE0Vj3IDZyGCQWdvyq3+CNWh5ZLg0AqeiOlHb2kwMgLb3hsR12tcvguuFpD4pzm85MvFgNB3nn8TQMiMvde07nNGhMH/PVlR/YQxsd4wdW/a0Ju8Zp81o5xVRZMl4Ja6Cw5BFIq8T91RuZPx9Ws+TM+VQgUduFbWot+lY0DPdBUb9ERBsTyJJW+/p5fznyB8mJquL5TD4PCwE4qO/8QLEH7H8ySUqChfXeWwcXQExUlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUU4sW414wtdSnz85b5I56ylNEg+UUF/OObeD2skbUw=;
 b=gg2tepca97xPVBn978U4j2lhkPqmLQc1g2JfJGB2hoi+Uq5y4PyQj14OLOtTJdAQzfnrT7cnkEC7hJ234F8jAl7g5dfZaipnu9s6KBhkdxhcqRCowhIvHgFLvMVIWf+Q9+uwg8gEqEvwJocSzknwIyhMn00IZTqAbA64kDuaZiZySGQks+R70wTVy5LT6BM7rPeox64mzSAqLwARef/kJcRg0ddav4y3TU3VJ6DHk5pMu9U1YPlngrOVg0Q+ssbEgCtKkBSYUyFO/90Suq+2jSejwGR8ep6BPmdc46mQWL0qrL2fBmv8NYS6Jq+vq+wzMb0eJG2S6pObAb4IzZN30w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.136.252.176) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=stryker.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=stryker.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stryker.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUU4sW414wtdSnz85b5I56ylNEg+UUF/OObeD2skbUw=;
 b=rRxrTULSd3so1wOcoxZ4OKSRHuLXHCxVKuspu9KHVFJax+flDkJes2twwnNy9h3lkZ7LBXsuNHgEniWXMgjsiBGte+D0Z/PUjC2QAG5vs53QSIBL90ZDMoWEzoBEIovip2TQKiICOqnT90gO+Vvl71b7BQqd22JQy/09YRntVOa1vNZJGkrgW7HkTuTpvOkYvWP+rZcG+nh6xkFBonY46choA9Yfb7TYJ4xvildDQkZtQoGy8W4pg8WSGOVUg26rX7NKaEfZV4yQj2QGssAP6ta5Mewd7rYY/69ACoL5cLKM68kzI0XFv/TCsQTsTuZNwbMiFJGcaKxVehJPTfP5cg==
Received: from MW4PR03CA0170.namprd03.prod.outlook.com (2603:10b6:303:8d::25)
 by DM5PR01MB2314.prod.exchangelabs.com (2603:10b6:3:9::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 10:24:11 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::dc) by MW4PR03CA0170.outlook.office365.com
 (2603:10b6:303:8d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16 via Frontend
 Transport; Tue, 9 Aug 2022 10:24:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.136.252.176)
 smtp.mailfrom=stryker.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=stryker.com;
Received-SPF: Pass (protection.outlook.com: domain of stryker.com designates
 64.136.252.176 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.136.252.176; helo=kzoex10b.strykercorp.com; pr=C
Received: from kzoex10b.strykercorp.com (64.136.252.176) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5504.14 via Frontend Transport; Tue, 9 Aug 2022 10:24:11 +0000
Received: from bldsmtp01.strykercorp.com (10.50.110.114) by
 kzoex10b.strykercorp.com (10.60.0.53) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Aug 2022 06:23:51 -0400
Received: from bldwoapp11 ([192.168.131.10]) by bldsmtp01.strykercorp.com with
 Microsoft SMTPSVC(8.5.9600.16384);      Tue, 9 Aug 2022 04:23:45 -0600
MIME-Version: 1.0
From:   <noreply@stryker.com>
To:     <wos@stryker.com>
CC:     <kvm@vger.kernel.org>
Date:   Tue, 9 Aug 2022 18:23:44 +0800
Subject: DIE WELTFINANZKRISE KANN SIE SEHR REICH MACHEN!
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Message-ID: <BLDSMTP01X0ygYHZj4I0013f26a@bldsmtp01.strykercorp.com>
X-OriginalArrivalTime: 09 Aug 2022 10:23:45.0316 (UTC) FILETIME=[1B174640:01D8ABDA]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49875a65-fb91-45b7-56a0-08da79f14d3e
X-MS-TrafficTypeDiagnostic: DM5PR01MB2314:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OYfayCPoNxFDopbprvANGeBMFaFyxIVfpSEIk6IL/JfktTNTkS1SFMwOmIQggjDuUSks+Uey/OakpKTu9timzji1a+dTDdi6eENqqIpXtLx4N36hUUF4ny7ARFyGtDT1LL5KDljgQ5uV60ngkVeDyVMQ2BmW36N2Zpz+Xloz02vuaR8gtjDj+HJt/9QqgptpdNF/kmGB122uRP5xL4pQdj74T8gOLWIzjvplfGYXur2DZvKIRt8TnWwh/hwXiYuBH1b7Q/ImXdxlNJwInz6M+dH6wWh0ayUbnW2pJSAa1uz5vFQunjiz11pqoV7Is03eyMtxZZyG55XXsBbH+p/LVugNDRC6KvkBSY910XEOcuF4yEuRkEPG1BeINPJmzFBIy1KjyDeyFTlySJBuUwyLgPen/bDdrDOd3N51em+m/X+SkJK+CIJQKKOKGVcHFhMqOcAisFJlSXR2eamocaJ0WdB1OZOtdMAYeBr+EZfwCUHV15FT+la9TaYTkOvDOZSqpqB/obKoz8uwfatYjdzSTB+VnlZBk+vwtSMW72wd9LWH+FUKYvJpU+Kx+TpR7GumliZdiWAKuwn+3CSU2NX7xy5Gtp52C56//zkSmCTGDHLQYOaKE9BPpKlQ8jVKKpZOjVsn0sZS7uQpyUphvhsVv+C4jnXPqLUIjH/AE0FBRKGK7hB0LghIocIVdzrtV+3I1WvQgUM1jUl5JZixJLDSd1KuAOUrXa9buOktJ8aVVpevRoXGHapUFJ+Jbl8gQnZdDmycwXIRlRLkgqV/UJ1+SYdSfM3O2Eyq0HNr2mo/+Jj1YH752czBVHzbPmQhwwMi
X-Forefront-Antispam-Report: CIP:64.136.252.176;CTRY:US;LANG:de;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:kzoex10b.strykercorp.com;PTR:ip176-252-136-64.static.ctstelecom.net;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(36840700001)(40470700004)(46966006)(316002)(82740400003)(82310400005)(356005)(40460700003)(478600001)(81166007)(2906002)(6636002)(41300700001)(70586007)(70206006)(4326008)(36860700001)(8676002)(2876002)(5660300002)(966005)(558084003)(40480700001)(9686003)(86362001)(26005)(6862004)(336012)(8936002)(47076005)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: stryker.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 10:24:11.4013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49875a65-fb91-45b7-56a0-08da79f14d3e
X-MS-Exchange-CrossTenant-Id: 4e9dbbfb-394a-4583-8810-53f81f819e3b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=4e9dbbfb-394a-4583-8810-53f81f819e3b;Ip=[64.136.252.176];Helo=[kzoex10b.strykercorp.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2314
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

DIE WELTFINANZKRISE KANN SIE SEHR REICH MACHEN! https://telegra.ph/Deutschl=
and-hat-eine-neue-Einnahmequelle-von-321525-Euro-pro-Woche-08-07

Follow this link to read our Privacy Statement<https://www.stryker.com/cont=
ent/stryker/gb/en/legal/global-policy-statement.html/>
