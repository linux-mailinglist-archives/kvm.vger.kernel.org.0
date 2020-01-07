Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36814132A89
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 16:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgAGP53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 10:57:29 -0500
Received: from mail-dm6nam10on2062.outbound.protection.outlook.com ([40.107.93.62]:35169
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727974AbgAGP53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 10:57:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T9+nVa7V/lR39U+OMMC7SwhVX1JqgjBfjMpiDG7mzvGz3AYD/FA4dFw6fa0vPBm6yZCCvnYWUWp17VnZYviMI3rlBMns/5eE7lmNjAyWipqzfpK/ypVLasYkNRr/67oPmW6FRYv9Tg7cnqMRO+M6PY5q30rx/Y1AYnNx4mCpV6O2AEGzF7x84YIub+7/T1YGhFCNTtbtiW1UMd7IwsewhSLYBvXZsPG/Bw18s3ZkU7UE1+8jUq0lSn9NtOJbZ09OygpzZPm60ae325Z9Yj6oFaHLgkSkNOt+NE8+z9NflYm1O3uDBQR5MSpdBAFUbJR3OAKibmV256t/Gkhg9GNTDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUPDoReg5JYfCSVvE/+SE0qXwqI53EaSx2COCtuYDQs=;
 b=AN/QgGSqP0c1D6LJG9PzT8o3mB43e0h6CAvEMPTb+Du7pEp7gBMUaVJ6bakFibpZaL5uSEpziPnf5GCFozJl43uOfIA4j/ERDnqZB5R3FtqBbXdB0PwETFx62GRjFcHuZ0JGkKjmfQifqoNeUFj/Y6ME/x2p4uX4ALAAayIfB/dHyzkkiNAxMBuu6dMhiLLeRlsvS5fBT7050ieO+y5LkNH9KzdWIkee0iYErGBPk/FCTJep8fsFuDbNyom3K9VvbzacgjDwaXJOcn8jtNHfNurNF0AViOfNgIkZF/t0qyH3B9NM/YHBYTVoud1x+RvDdd90lU46zYb7TxiNeEfHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 81.255.187.177) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=exfo.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=exfo.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=EXFO.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUPDoReg5JYfCSVvE/+SE0qXwqI53EaSx2COCtuYDQs=;
 b=SYZIREPxYZx0ENoArBXNVlL6T03brACzj6bg0Tfkk8daAXze/7P1oqt4mYvIShOy7xMh+p8cB9oM6h9EGPfG+8S5SqesKdC/vU6/ciuDVh4TYjptLyCeDYJzree90AvQAcwxYxAtGsmah0x4vYzj/NgnKgnSGO1OhXhmDiMd/Tg=
Received: from DM5PR11CA0013.namprd11.prod.outlook.com (2603:10b6:3:115::23)
 by CY4PR11MB1255.namprd11.prod.outlook.com (2603:10b6:903:30::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10; Tue, 7 Jan
 2020 15:57:25 +0000
Received: from DM3NAM05FT037.eop-nam05.prod.protection.outlook.com
 (2a01:111:f400:7e51::201) by DM5PR11CA0013.outlook.office365.com
 (2603:10b6:3:115::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.9 via Frontend
 Transport; Tue, 7 Jan 2020 15:57:23 +0000
Authentication-Results: spf=pass (sender IP is 81.255.187.177)
 smtp.mailfrom=exfo.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=exfo.com;
Received-SPF: Pass (protection.outlook.com: domain of exfo.com designates
 81.255.187.177 as permitted sender) receiver=protection.outlook.com;
 client-ip=81.255.187.177; helo=ON_Mail.exfo.com;
Received: from ON_Mail.exfo.com (81.255.187.177) by
 DM3NAM05FT037.mail.protection.outlook.com (10.152.98.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2623.4 via Frontend Transport; Tue, 7 Jan 2020 15:57:23 +0000
Received: from SPRNEXCHANGE01.exfo.com (10.50.50.95) by
 SPRNEXCHANGE01.exfo.com (10.50.50.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1531.3; Tue, 7 Jan 2020 16:57:21 +0100
Received: from SPRNEXCHANGE01.exfo.com ([::1]) by SPRNEXCHANGE01.exfo.com
 ([::1]) with mapi id 15.01.1531.010; Tue, 7 Jan 2020 16:57:21 +0100
From:   Gregory Esnaud <Gregory.ESNAUD@exfo.com>
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Topic: [Newbie question] Why usage of CPU inside VM and outside VM is
 different
Thread-Index: AdXFchc6k6fghFvyR2Cb2NX5qpnvFQ==
Date:   Tue, 7 Jan 2020 15:57:21 +0000
Message-ID: <8254fdfcfb7c4a82a5fc7a309152528e@exfo.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.72.130.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:81.255.187.177;IPV:CAL;SCL:-1;CTRY:FR;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(376002)(39850400004)(136003)(189003)(199004)(8936002)(316002)(36906005)(8676002)(26826003)(478600001)(81156014)(81166006)(2906002)(70586007)(70206006)(6916009)(108616005)(24736004)(2616005)(26005)(356004)(186003)(7696005)(5660300002)(4744005)(86362001)(336012)(36756003)(426003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY4PR11MB1255;H:ON_Mail.exfo.com;FPR:;SPF:Pass;LANG:en;PTR:extranet.astellia.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff151c9d-1a88-41d9-c197-08d7938a48f9
X-MS-TrafficTypeDiagnostic: CY4PR11MB1255:
X-Microsoft-Antispam-PRVS: <CY4PR11MB1255A3AAD6673104E4D689CBF43F0@CY4PR11MB1255.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 027578BB13
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OMCLrpacFF772OPDM4g418MuZREiAY+6usDk1eiIT/GMCULd7fUxW1oY/Z9+58m0cYycKiqsJsMnhLYbDb0883iHBtAgniLWHbXVTawedgAA5vZvB/YN5+1HjvFSL3u16/mAFwTs+36UmWD8AZmodry3ihctkvNVEIK8ZbU0xYUrLA4N6UI9ZsKXSGBmQDyksyd+8QCeJp+xrnZI35MTpHpx0V8swNLSJlPI/zbKnJA6JeATLD3ekUgHIeEC8zGaJOjJIn0QmEcNNWLZsHFXKZxVcF6zpeG9m+sUwobifP8Mup50LezMvmdIgdItGK7Qm0hJw47ffKMb4mxjYS56fkXEteAD2V5jp60TKRCNXul+26o4VAKgc4SY5zSydyFv+e7dCvB/pT3ETh/dYPfPntiPBaWYZhwX13uG6dddS7Qg9K66gj4PLv0stvbFL54t
X-OriginatorOrg: EXFO.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2020 15:57:23.1969
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ff151c9d-1a88-41d9-c197-08d7938a48f9
X-MS-Exchange-CrossTenant-Id: 1c75be0f-2569-4bcc-95f7-3ad9d904f42a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1c75be0f-2569-4bcc-95f7-3ad9d904f42a;Ip=[81.255.187.177];Helo=[ON_Mail.exfo.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1255
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello dear ML!

We have deployed our application on an openstack RedHat platform with a KVM=
 integration.
Our VM have 14 vCPU 'reserved'.

From an hypervisor (via top command) point of view our VM is consuming 9 CP=
U (900%). This was reported by our platform provider.
From a VM point of view we are consuming only 2 CPU (200%), with a top also=
.

Our provider claim us to explain why we are consuming so much CPU. But we c=
annot troubleshoot the infra as it's not our responsibility. From our point=
 of view, everything is ok.

Would you please give any bugs/config/whatever that could help us to drive =
our provider to a misconfiguration or whatever?


Thanks very much,
Greg
