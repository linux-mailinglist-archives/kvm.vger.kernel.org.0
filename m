Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1997CBE77
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 11:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234147AbjJQJHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 05:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQJHq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 05:07:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3A5E8
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 02:07:44 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GKO43v027752;
        Tue, 17 Oct 2023 09:07:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3Qdo882TLT9Xay5yaznUZSBOgkLWUAfMd2ekFmARuVE=;
 b=p2Cgr5o3nxSrn1+tPqA68np0DHqxId/QoO317g8Q6Feu2vDGK+jhnpAKB0DJ9MBUO2vj
 1haSR9SbSJ9FROMC44ZxZJOMc5RP5lqKo5zFh5+WukkuY3L3DhRz4Cd/FmU/3y13GYWE
 QSdyKJHIcXWyhCebe2aaDjag3XrrxBRVZkjbKRXEq6KL8ulEwkoj5sFhPgBcsci0ugAW
 g/bh0Rho9OyFRdPSZRQJWx1kowGa4/KCFNaYYA7fydRFP1w5jo3vNvWLc9MZ+m1YSdTY
 hsZMfStn/n9YmJZcM+f51t3OOwIzXWvqqdKsfHzP0qw3ca91GFZLz9T5So7IuEylHqBE hw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1ccnma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 09:07:19 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39H7ujCb015292;
        Tue, 17 Oct 2023 09:07:19 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1erekt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 09:07:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqjk95Z7hs2TGWfXTuJKE95OpdP0ZlmdGYm6WT4i+w12nzLL/yTCNRMQIheSJxsl93T4+GFaoR47rZFoABq1ttfkCniy58hXLc5IWElRgMqwZA+qKpc3ua68bRuSPrXo17oi3SnF8xn6eiPPNW/xY5ICd6J89xhtkvxhEAKQk12vT2p9GUVRdf1Im183aVgAiCS+RDK7NkUZZXNVfPncDEUjPlN5+n1bvygQ+Hvz6xE6mitKTihyJdEOw7IX3ljfPktP53W0AL3grPwXtgav9zD+1slAbil0AOBeH3mRWaeKlV9JvilsX9BicULrlidZ5eRymcWEJf1Oi8GdfvKrqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Qdo882TLT9Xay5yaznUZSBOgkLWUAfMd2ekFmARuVE=;
 b=ExHnxzcc82jGKlV/b+CgQH6W7ShAHJ5zBNECsVHnb5z88kIIfn+XYd1w4Vi7DomGinz6lNanWetTHnZvw+SfaM62lwUWbLkeIZTzTfhe2I0O2pKB+HQfhtHPi8kNtzGCAW/cGKUfwiZH9e3CPU1x46i/3kG/V2/TBjEPooa3bNX5/hs9rxcK3V9VxYdetoWZ+0brLGyMxinnEuVKDiE4qLt/prhrl29SbcYACxH1C1GLi1ktP7DnewplFabYXrdGvyfqdsKMB6wSlJdpYV2txI1VHNJwttGnyKaUU4qdpTmU+Va2hbIF/v5Zqy9zzLus5OOZG+H0+JVuUUxh+yFkrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Qdo882TLT9Xay5yaznUZSBOgkLWUAfMd2ekFmARuVE=;
 b=SJeSLHFJXJGFoZMYegARADIwtLsvWMEms8iAGV3QXDnNE7oY7Oj7zQB19GqGyqeSR7Ddzxq2Zy9HdwfCW+IAi6loF38hlEXyVuci6k4xPeMZ1KjDGYF4yyFbGXTJVlyWNVkUNRzRT/MkOyEnx+3N92t6UJXqMZ7j9Ir5oj5YdYo=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH7PR10MB5723.namprd10.prod.outlook.com (2603:10b6:510:127::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Tue, 17 Oct
 2023 09:07:17 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 09:07:17 +0000
Message-ID: <401bae66-b1b4-4d02-b50b-ab2e4e2f4e2d@oracle.com>
Date:   Tue, 17 Oct 2023 10:07:11 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain
 allocation
Content-Language: en-US
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-17-joao.m.martins@oracle.com>
 <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0112.eurprd04.prod.outlook.com
 (2603:10a6:208:55::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH7PR10MB5723:EE_
X-MS-Office365-Filtering-Correlation-Id: 36f39e19-44fd-4b44-9dae-08dbcef075fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSWY73oMrP0vKOfeQ+/y6Yywq7y+yxEE3yPgNEOxyO7KUBJciT/Bt/NfVDNbwK9JD0CbGKmxs8EBUDZjp2rGYU6G632QID5FzYJJ9iW/NmGvXgAdRmSFkhGx6tbGN01D6yZiFYtZbPBn6neoSEmJJcl3xmm64/m1oEmn7BbZUR6k5DGYRNzZgQjE1DZK2/OuTj72zStr/JzQM2bT9OyKZfiqmw3VvqWJMHu8YDex1j6ic9kEt/8VqfDAaKWJ1frJKN0Ck0i19UZMQZSyWDyYcAnknS0TiKFn4srTesLDYCF6hcF1AySPrJnobS5ysl6rC833obyE4+hUJ4Ndc5nO+f2XYqIN0ZwJqOo/yrDgduuMftEsg/vEmDP1SuEBwG1+RFJvr+Vrqzhz1vGX6svctpaySANpZdSUAka4COfL5UkdY64z20Ja3kmVtwJ5C0CpVsekZ0Q3VCBW0c3f/Cqy3K7Lk0KeK8jhvu5KmneTplX7ULBHfeRC0AYjB6b3rYo0XeCmnogFaV2U8EwP8Rdvttfjz3vH/fQz3gcTgT3y+kmUfiqg/05cffkcow1m3/a00nidTV21xuvHQ92T4kzblXOjxpAEAxIXoI25wVNpknebZzKm7gTAueCI5nOxZmtZtRAsqky3H9nb8QmyA6BkRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(39860400002)(346002)(366004)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(31686004)(6506007)(53546011)(83380400001)(4326008)(26005)(38100700002)(2616005)(6512007)(86362001)(31696002)(2906002)(5660300002)(8936002)(8676002)(6666004)(36756003)(66946007)(54906003)(41300700001)(316002)(66556008)(66476007)(6486002)(7416002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0ZBRjRQOEkwTGV5Y3ZhTEVaQWlybEtzaFF3aXV4aUR1blBRSlZqaHBjcVpF?=
 =?utf-8?B?R0w1RjNqUU1EWWQza1l4emw3T1ErcEIzSVp5NDJTbEVnbmZ5VWZJbkR5WmJw?=
 =?utf-8?B?YllDQlJ1a1pBckNLYW9DbnkzSFh3UzVwRzA1VEkvNGMyWlFCZi9VbDJ3cGhK?=
 =?utf-8?B?cWsrM28rZCtpS0JibDhzaXpDVnFOTFV4b2F1RWhPeFJyRmpvektJcmQrUlZh?=
 =?utf-8?B?WUlPWFlWTFVNWmhNMVlIVHpGMlVKbEl6b3NJTUM1RHpUYjM2Um1UeEI1cHF3?=
 =?utf-8?B?eUJJRCtjRHR6UUFxMklwY1creVBwUVI0NVluMnpkVEZCSnZIUzFxdjAxREEy?=
 =?utf-8?B?WWRtdkRvMUVQTk1QOC8zZDNUNTFJMm9nc0J2Ulo0SjdpTjBUV2NVVmVaZWJT?=
 =?utf-8?B?ZW1kckRMSlRzdnZwL2Nxb2ZBWXRBaHMya1lhRkplY1BRbDkzSlU1WkRsSWtj?=
 =?utf-8?B?eVZOV085NWxaa0xxd3VReVN1ZHRWUmgyTUljR0tudnJMU0hydVc2NU1hSmVs?=
 =?utf-8?B?N3FWUGZ4eUhVWSs0SjNZQW1xSmRCL2FvVzNoR0l4VTZhWmVUQkVYK2xuY2pB?=
 =?utf-8?B?UXJtaHkzVTZ3MXZNWGFvUEgyR0tva0xnUWdVM2w1Q0prNnUwdll6OGhvN0lu?=
 =?utf-8?B?VzJmZGNUa3JQbHErUEZjT0FJb3NFVTdvMys1YjkrREhDUVdYWko4Z1dzdHlW?=
 =?utf-8?B?KzkrdWJUWnZiZVlraSsyWXVoMi9GQlhabU9BRmQ3RDBUQ09wK1E2d240S0xR?=
 =?utf-8?B?ZHdUdHhUcFVmUytBQjA4ZTNzd3VDbkxwVjc2U2FCNkEvUThvcE9BVy96WUpn?=
 =?utf-8?B?SnN2c21vUkR4OFc3NkFlYjhtY3NBR2dLRk11TDZTMFBLMFBhVWM3QUIrd01M?=
 =?utf-8?B?VGhMQmxiei9Sb1pBSGJPQ29IUXorL3VDQWxVYlBkZUdtWEliTnpHSGJkTEhE?=
 =?utf-8?B?RktlMmpObCtKWHlhUjhCNWUvQTFGS2pKT05Rd2ErZ3BPRnl2Q3JnY2N3Y0dv?=
 =?utf-8?B?VzBjL0tmV3l3ZG9OTUhObVlLWWRZQzI2b2xaS2ZQaWxScDNzTUVFdXlCSmIr?=
 =?utf-8?B?MUh5b1lSVGxONDJpVHowRkZKYUZudWY4VUtaSzRzZk42QkZkZk1oZGwxNElU?=
 =?utf-8?B?Y1hsUE9KZ0VHOTZRSUp4eTVxYTk0enFDRlZNdVZSaU9pRUgzQVp3emJiZGVy?=
 =?utf-8?B?RlNVdWJUb25KS1J4WldISU5la21zNDVDazliblhuUjdNU2UxZmRRZm4zT1M5?=
 =?utf-8?B?dVI1aWI2M0EwM0NoWCtEdlk0K1FQVSt4NEdlc1V2cEtickVOUGVCWEhQMzJ3?=
 =?utf-8?B?ejFyTS9SRjBObm9MV3pEWGxBSUp3L0dxeGJRRHFLZ0czNjR5eW9FMXorckti?=
 =?utf-8?B?cUNScjgrWVBsd3ZqekY2M0RjMmI5c2s3QnJrZ0FOczlaTjJrQmdFVnlyWFd6?=
 =?utf-8?B?cnBqUkowMHBobUJkS3pRSjhVY2p2Z2ZoUUgvRFFLTDQ0YURLMGFzZjdFYVA0?=
 =?utf-8?B?Y3o2Y3ZLbmhEbW96d2Q4aVJ0ekFaWk00YncvRFZOdGx1UUdhYytpeWwwTjIr?=
 =?utf-8?B?Ry9MSnNISm82d2pKa3gxZ1VLL1h3WTlEOTRWcURmTFBwaHVTb3pncGx3eXB2?=
 =?utf-8?B?eUdhRlF2MHJFQkdmNW5IMm43TW5jeldZRGxRRXBZUXpJZUg3NjdIS1hlOHpy?=
 =?utf-8?B?NW5pL0ZLU3pudzdtSHNMcGRObUNUVGRkUjNVbmRXYzJqaWRFY3pLMTB4b2cw?=
 =?utf-8?B?cjkxUG1qV21Vc3RoTUJ4NDFPYWtFTGIvQWZNY05PWktCK2VHQTVIYjZiemdD?=
 =?utf-8?B?VUM0TVlNYXFpaVlTSWRDVDJSY3J5UWJnVXVxKzB0U1RqU1kzVnRZaEhCTnNj?=
 =?utf-8?B?WnR4c25tSmQ2WXN3MktsVWxNMlp2N2NsUWFQZ2lpZnlwSUJCYnFrSFJDdUx5?=
 =?utf-8?B?YTRiTDF2OXYwSjNKNGhLSWs0b0JvaWRnMERQWW5jbVpMRVJHejZ4aEhNeG5V?=
 =?utf-8?B?dFRuYTliRUQ5amJKbFZjMFZhdys5bEFWRXhqdG1aVVJwak5xbHlEb3ZTaUVG?=
 =?utf-8?B?UFlhZ01sNDdjNGl0ZCt5QzMxT0ZndVBOeldDTkhYdXFlTW1KRnZ6aUk5VGZV?=
 =?utf-8?B?dE1icXFwTWhtb0lKQzJma2pTMFpLOTFXN1pCYnAzdXpPaXk0Q29TbWlIUTlu?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SmZjaCt2RVpENE03V2pJSWYwZHFFb0owOWZhaXEzV0pwTGE2SWlWdEF1Rm5I?=
 =?utf-8?B?emIyTFJQdjVYUHEwS1pMb29uajJ0S0ZtVml1NGIrVEFqVWhDY0J5WEUzUmVk?=
 =?utf-8?B?OGZjUDh5bGVmK1dmd0FxdXpwQWZSbm9FWnhvREZUcVR0VXYvd3l1UTZRbEtu?=
 =?utf-8?B?dm55QTU3TjN6Qm1BZ2V2R0x0aHd2VjI3Ym9OQ0hFbDVNNk1aQ0I0NUs0dzBO?=
 =?utf-8?B?Z0RJUmdkZVhDdk9ZZWlBRzNuL0ZJQkdiZDlVUFh3aEVwRkZYbjcramZBMjdq?=
 =?utf-8?B?SFNmL05ucDlWQk82ZVUzZ0psOXRRc0NJQUFmVkpzd1kzajNtL3lhZm9GN0li?=
 =?utf-8?B?bDk5M3pYVkNQZXZtL1JibWlQN0Z5RFFsK0kveVBBbzRUaEc3ZUJIWjhxanor?=
 =?utf-8?B?c3YySURJL1ZkY3cvYXByblA4MzBxakZvTVRTSUJUdjhIcjF0VTVabkl3UDBC?=
 =?utf-8?B?VlFNSkdUL05ER2VJUmlTSkFkektlbjV0cEhwVTRlK0VXWG5oVGRibkdGNUtI?=
 =?utf-8?B?OGlpSWhRZi9HWUUwZWNTVDl4elpXQ0h0a1I4Z25KT2hOZjVWWFhKTzU3TSs3?=
 =?utf-8?B?dXlZdEExSzdhV0pDT0JLb2N1TmlWTU55SGVPT1I5RWpxVE1HemVOMlVWa3dL?=
 =?utf-8?B?QkFmSE5kamxTYlpjYWFpRTV0eEIyc2I1Z1Z6QVVoRGdCa014OGlIQmtYU25w?=
 =?utf-8?B?SzJnL1hxWUZTSXV4cENTbit0ejNublhFSGl3cXYvVVI4TWVCNUlxVVBhWDRH?=
 =?utf-8?B?aHEwbm9uMEFVV01CSXdsUFZvVFoyMkYzMXNhZUdZR2VEQzlMclVIRXMxWFFx?=
 =?utf-8?B?UUhhbi8yd0VSbHZPZTFleFdnWldzOFdDeVVyblhTTzh5dUhhMkhnako1Umlv?=
 =?utf-8?B?VHlQUGxvMmh3alMzMWEzcUgrS2tmK1FXclVmbEdCamN5cUYyY0NHc1dHanRH?=
 =?utf-8?B?elhOOFlwSjJNUU1Jd2g3NVg0cUhpRExrSjl0UEtMSGdCMkY3eFZSTzY0TFZD?=
 =?utf-8?B?bzdlM3VJeDNXdWk4WXhjbTVXNTA4R3pSUlB1dFFweGV2eWJSTHBQZVlnTFA0?=
 =?utf-8?B?MnFDT2lGZmhaMHRjcHdJbFpTSXlxalFURS80OHdjWVFCMXZOa3pBbU9ObDZj?=
 =?utf-8?B?KzU4UkFRSTRWREY1TW03QW9yM3RGYlpMUnhMQWRUenkvYXBrRHB6eEhSVm45?=
 =?utf-8?B?RVhUQkFSbDhjcTQybXJjUktYUjZwZHEwWUhZL0J4eDNBOU1EMXpLcG1obm5Y?=
 =?utf-8?B?ZW8wbFM4Nldubmp6YU1teUdtWTN4RTN3dThPTDdoMlZaazliZVhUSmJrTmRh?=
 =?utf-8?B?RlRaSzN1SnFvT1JkVEpGcVJ0R3pXaTV4d1dlRHRTUHRwc1R2dzUycFd1c3hY?=
 =?utf-8?B?K2F6MTRIQ1YzdUhLaUxxcFVoVUVXa1kxMTlBbjZBRmNtYnNUWWZBWWhQZXRH?=
 =?utf-8?Q?MuPtOHu9?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36f39e19-44fd-4b44-9dae-08dbcef075fa
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 09:07:17.2038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrrRcrcSGb8wcpb1iJc9N/dEM75y1JDV8UgeU2QhKYj1fZzb435Oiv+Lu1zJ8bIDTbX54tHVHip8BNgwONQWZ1pu+SB9DCombmQl8SNZAuo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_13,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170075
X-Proofpoint-ORIG-GUID: SWeZIvpZOPb8KbmFcdJ2XuKg4nxCzOh_
X-Proofpoint-GUID: SWeZIvpZOPb8KbmFcdJ2XuKg4nxCzOh_
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 03:00, Suthikulpanit, Suravee wrote:
> Hi Joao,
> 
> On 9/23/2023 8:25 AM, Joao Martins wrote:
>> Add the domain_alloc_user op implementation. To that end, refactor
>> amd_iommu_domain_alloc() to receive a dev pointer and flags, while
>> renaming it to .. such that it becomes a common function shared with
>> domain_alloc_user() implementation. The sole difference with
>> domain_alloc_user() is that we initialize also other fields that
>> iommu_domain_alloc() does. It lets it return the iommu domain
>> correctly initialized in one function.
>>
>> This is in preparation to add dirty enforcement on AMD implementation
>> of domain_alloc_user.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/amd/iommu.c | 46 ++++++++++++++++++++++++++++++++++++---
>>   1 file changed, 43 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index 95bd7c25ba6f..af36c627022f 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> @@ -37,6 +37,7 @@
>>   #include <asm/iommu.h>
>>   #include <asm/gart.h>
>>   #include <asm/dma.h>
>> +#include <uapi/linux/iommufd.h>
>>     #include "amd_iommu.h"
>>   #include "../dma-iommu.h"
>> @@ -2155,7 +2156,10 @@ static inline u64 dma_max_address(void)
>>       return ((1ULL << PM_LEVEL_SHIFT(amd_iommu_gpt_level)) - 1);
>>   }
>>   -static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
>> +static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
>> +                          struct amd_iommu *iommu,
>> +                          struct device *dev,
>> +                          u32 flags)
> 
> Instead of passing in the struct amd_iommu here, what if we just derive it in
> the do_iommu_domain_alloc() as needed? This way, we don't need to ... (see below)
> 
Hmm, you mean to derive amd_iommu from the dev pointer. Yeah, sounds good.

>>   {
>>       struct protection_domain *domain;
>>   @@ -2164,19 +2168,54 @@ static struct iommu_domain
>> *amd_iommu_domain_alloc(unsigned type)
>>        * default to use IOMMU_DOMAIN_DMA[_FQ].
>>        */
>>       if (amd_iommu_snp_en && (type == IOMMU_DOMAIN_IDENTITY))
>> -        return NULL;
>> +        return ERR_PTR(-EINVAL);
>>         domain = protection_domain_alloc(type);
>>       if (!domain)
>> -        return NULL;
>> +        return ERR_PTR(-ENOMEM);
>>         domain->domain.geometry.aperture_start = 0;
>>       domain->domain.geometry.aperture_end   = dma_max_address();
>>       domain->domain.geometry.force_aperture = true;
>>   +    if (dev) {
>> +        domain->domain.type = type;
>> +        domain->domain.pgsize_bitmap =
>> +            iommu->iommu.ops->pgsize_bitmap;
>> +        domain->domain.ops =
>> +            iommu->iommu.ops->default_domain_ops;
>> +    }
>> +
>>       return &domain->domain;
>>   }
>>   +static struct iommu_domain *amd_iommu_domain_alloc(unsigned type)
>> +{
>> +    struct iommu_domain *domain;
>> +
>> +    domain = do_iommu_domain_alloc(type, NULL, NULL, 0);
> 
> ... pass iommu = NULL here unnecessarily.
> 
OK

>> +    if (IS_ERR(domain))
>> +        return NULL;
>> +
>> +    return domain;
>> +}
>> +
>> +static struct iommu_domain *amd_iommu_domain_alloc_user(struct device *dev,
>> +                            u32 flags)
>> +{
>> +    unsigned int type = IOMMU_DOMAIN_UNMANAGED;
>> +    struct amd_iommu *iommu;
>> +
>> +    iommu = rlookup_amd_iommu(dev);
>> +    if (!iommu)
>> +        return ERR_PTR(-ENODEV);
> 
> We should not need to derive this here.
> 
> Other than this part.
> 

OK, will do.

> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
Thanks!

Here's the diff

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index af36c627022f..cfc7d2992aa6 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2157,11 +2157,17 @@ static inline u64 dma_max_address(void)
 }

 static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
-                                                 struct amd_iommu *iommu,
                                                  struct device *dev,
                                                  u32 flags)
 {
        struct protection_domain *domain;
+       struct amd_iommu *iommu = NULL;
+
+       if (dev) {
+               iommu = rlookup_amd_iommu(dev);
+               if (!iommu)
+                       return ERR_PTR(-ENODEV);
+       }

        /*
         * Since DTE[Mode]=0 is prohibited on SNP-enabled system,
@@ -2178,7 +2184,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned
int type,
        domain->domain.geometry.aperture_end   = dma_max_address();
        domain->domain.geometry.force_aperture = true;

-       if (dev) {
+       if (iommu) {
                domain->domain.type = type;
                domain->domain.pgsize_bitmap =
                        iommu->iommu.ops->pgsize_bitmap;
@@ -2193,7 +2199,7 @@ static struct iommu_domain
*amd_iommu_domain_alloc(unsigned type)
 {
        struct iommu_domain *domain;

-       domain = do_iommu_domain_alloc(type, NULL, NULL, 0);
+       domain = do_iommu_domain_alloc(type, NULL, 0);
        if (IS_ERR(domain))
                return NULL;

@@ -2204,16 +2210,11 @@ static struct iommu_domain
*amd_iommu_domain_alloc_user(struct device *dev,
                                                        u32 flags)
 {
        unsigned int type = IOMMU_DOMAIN_UNMANAGED;
-       struct amd_iommu *iommu;
-
-       iommu = rlookup_amd_iommu(dev);
-       if (!iommu)
-               return ERR_PTR(-ENODEV);

        if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT)
                return ERR_PTR(-EOPNOTSUPP);

-       return do_iommu_domain_alloc(type, iommu, dev, flags);
+       return do_iommu_domain_alloc(type, dev, flags);
 }
