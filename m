Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573B35FC6BE
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 15:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJLNvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 09:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbiJLNva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 09:51:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC4661B11
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 06:51:29 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CCxJNs031413;
        Wed, 12 Oct 2022 13:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EvElvepobACD9OVP98WAthnKcWYkXB+qj31M/mE8YyI=;
 b=QmDP7GEPpVBMzPE9XLxET0Xr4WQV5f32w4h45leyf9EAz2ZK/7KCo6ZesVJDcCKelun5
 y8KfCEq8Yt0Y78ZZj3luXxly8JErdla6023Vo00oX8YeTjqNoi8Z8IVNTKjR9b33ecJq
 M8VyCwZz40KTuG7HgC08zlJ2enVD0bGf2G+/wnU4D+t4GtH3Q1msBi+HgoL+2QyQCmp+
 BNGfsZzsSgY1E+zUtMClf4t8fLZVkKv9s8XN432iGkTetn3BPyRltu6FgftoiMthlbjq
 +1E13EE65/bT8PlYAbh96O960pHou6+ndNjR9Df8s62H1VhkaqjaF+HdTiQDitHYw2OS 6A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k313a1u7d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 13:51:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29CDjXUT008639;
        Wed, 12 Oct 2022 13:51:03 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn4ve69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 13:51:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVTeKvZkZgpp9iynGlwpcbJ6W52um7E/jRT3kFX5Nvzb5IbCkby7zBOxGywFC+xdfWjMBF9L0k+9pnbeXoAtdV6FcjWdu42OFNP3cHNAsCGAmt5+STgBo99RPwz03MZXBMD/1np/kTUE92cC+oCbgbpPv7mRrxWZ/tydCk0p2faN6NmxDTgyOwn9eukoA2/AH1sXbOs4pVQOS7XO14ugi9vQiPBdMAAVY1tkyjTBBYNUISuFwTcDX15X4T4Ifb9C0L5cdCw70p9h1jwL40W4ZX/1RlvSCIk0wrF81xiA4+pkEos1HHGhI3fgdhYuloociILw0J0Ub0Kowf/BuSYbmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EvElvepobACD9OVP98WAthnKcWYkXB+qj31M/mE8YyI=;
 b=aZx9eeRNv56etJIRRVrXm+SgPCx7Wfy7pJaJffeAzjNA2q7m48+vWUkBFqsfCYAtUKYJ6cScpf4VsQeD4J8L2tSx6VUdgb37kf1zkL9nQnF++ShvPkkq2wkX5AQgqpkwHuneD6Mz5vrFC6kQjOGnrzFuxc7UbjaucJfix1hxicZE9llrG5UWnpCWN+VlYWYIrF4UOZvlm/xLi/3rHoDojdkYbrtFIeEgJylNT4XTJYD8YzV/NO99qvKj33c1TotoSzNrssSb5liVO/zOCdR7N0CGXWx5yRoqhNyB0jl0xaKtZvstIshEQHDTeZz7tLsdeZj+42M4WsOCCKHjhRNtdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvElvepobACD9OVP98WAthnKcWYkXB+qj31M/mE8YyI=;
 b=E9rN1bZfMBQ7/7iVSLpV0SVh4+k79oa0qew7s5EyeZOksyJU0TVX9lQPw3whynHr6Gr+6+hu6BDC7nmq/6sQT6YZZ6pt9IDGIIfTyuQtavu88yDOoAAFy4cHjhN3e2h1xh0tZsDs8QcKDG5RxnBGRSL/5GdY09kYSyKMO6aZiCs=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by PH0PR10MB5730.namprd10.prod.outlook.com (2603:10b6:510:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 13:50:58 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528%4]) with mapi id 15.20.5709.015; Wed, 12 Oct 2022
 13:50:58 +0000
Message-ID: <f9e6ea0b-ebd9-151e-4cf6-6b208476f863@oracle.com>
Date:   Wed, 12 Oct 2022 09:50:53 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
References: <d5e33ebb-29e6-029d-aef4-af5c4478185a@redhat.com>
 <Yyoa+kAJi2+/YTYn@nvidia.com>
 <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com> <Yz777bJZjTyLrHEQ@nvidia.com>
 <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
 <Y0Vh868qUQPazQlr@nvidia.com>
 <634a8f2f-a025-6c74-7e5f-f3d99448dd4a@oracle.com>
 <Y0az8pNrA9jOA79k@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y0az8pNrA9jOA79k@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0171.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::26) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3240:EE_|PH0PR10MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 21163f6d-f3f2-4d4f-ea45-08daac58ca5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TUrmlweLTA9svj36TKsgfbsDmlIm3ukXYBmar4pZvbx9SuhVD7BT07iUzBpEcxwNgYpTu0abFsd+v+hyBY0R6yiXCidLnJek3HWi+Sb/OEt/BaciEbtp6yPfG2zp6dAeqN6z3e6zWtF9buurly1hPG/cwgdkrYxwg3WU5szIEWrxnPKtR1sBWwDMHkwVqlq06gdIow+lEUbeSlOhir4yfbCZgAC4daLZnOm8NiyM7mOggkyyCC3vTl5Mc1/cD1aDutfFCRSmyZtBGmc+xeYHlPJDF2UeuLmCOsRBTu20S3/Z57NgvP5PRZRmrCC6Gcjl0I3z9d/h3H7SNguUCYOLJgtqQwxjNyRJ+67zhwpZtmKzFPhdNpCev8RUxZoQRpnDTcINbblKSfUn0SApdsBf8jyyHgdEZs1lgf9J/2RTFz3RdM0nzw2iY8sAttB1qpQkUU7Q0mZMc7MdquhDyXULXWrvurn29vONr/qAOKFHcOnLevmRhUdSsyg64JSeT2F+9k6Ur1H/KlC2evDpyh8sqB5F50mWXR4O9xerupV002e6+oPRArYzrW2cHEYZ1a7CYq2f0CAITrPc41dZNSsEVJP5GoCpyZfBhZk7vgOVs636pEfW/hEXYB1DPquFmW3FBWrG6iANnBxNMG3SAqV5Qm0qtc0aeUWNim491t1RJPhlZsY1vwTBrrbwS1WKEU74f/YpdfYtH6cqqBdLzNGS7OZhmt6hsNRtqHOK0m9WpQNjKL+vPaFB55p5JDjIgNyz2A6im2M6f1VnTW0IRqPpfwmjl5WEyZXipe51GXZQhl5ENaL3utK8asFh93suaOIp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199015)(36916002)(478600001)(31686004)(53546011)(6486002)(6512007)(2906002)(6666004)(83380400001)(26005)(44832011)(36756003)(316002)(86362001)(2616005)(66946007)(66476007)(5660300002)(186003)(7416002)(31696002)(38100700002)(8676002)(66556008)(4326008)(54906003)(6916009)(8936002)(6506007)(41300700001)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnRJT3lNeHFIYXFxQ3lzUWFYcUVNaW1RZ2I2c3h0RzBqSzFFYkRGaDQybUdn?=
 =?utf-8?B?SjBxU25MZm13RDJvdldNY2JVV2dCZFJ3OFpUR1RUYUhhYVpDT0RPVUt5YnBI?=
 =?utf-8?B?bmRDT0paeUlTZTZGTXZuM3M1cTRZdERtMFovc2JDenhrNzVyK0pab3dGVFkz?=
 =?utf-8?B?dnJ6aGZVOGovc2E3cExQNnZOR0FBeG4xM3VXeGZPd0JpcmZnaXlxVVZHYU5l?=
 =?utf-8?B?SDhkLzg1aGNjNDU0NWI4d2pNdGw2MTRNWnhkV2dJQ1RlclJqVzVNNW03d3RC?=
 =?utf-8?B?QlBkVTVVWFMyQWdkYzlUVlJRL3FobmwvQkZEa0pGRnBGU2JlRXd4Q0Rub3hz?=
 =?utf-8?B?a0VlazNHemZyZ0pjY3Vaa1pQaGtuMFpXN3hCbEQ3dkpYaUQ2ZHk3OXZXaUhv?=
 =?utf-8?B?ZnNONk9Nb0FRNmJRV3ZWclBKMUFrMXJCQlNJQ2IyeWR6TktxM29pZjhFSkxQ?=
 =?utf-8?B?M3NWcXdFWVpMS05LNW5UZDFYTGgzek5oWUxvb2pQSFpWL0lLTjNpNERYNnJi?=
 =?utf-8?B?Q3loZDhWcDlMK0xzYit3U2FqaFJGalVqdWV2bE9aZEFWU0txM1UyaEYveHhY?=
 =?utf-8?B?RDNqYXB0aG00a2Flb1pHYmMyK0R5d29NZ2ovWjdjNVhuaVVCc3FVeVQ4Z0Rt?=
 =?utf-8?B?OUM3cU1rd3ZkandYN3dZWHB4NVdxcnNZTmxDemwzeHpmZm5uYWg3Tm1obk85?=
 =?utf-8?B?RUJyeTFqdFFTRzRxZG9ndEUvMFRUL3Z0T2x4d0xkNGNLSmFiOXg0N1d2R0Q3?=
 =?utf-8?B?ZGhpWDM0S1huczlMTFJKWHpuT3dCOFVYbWtNbEdBWnpLODgwY29wWEVnbDlr?=
 =?utf-8?B?SnVhRTBoV3VleU0zS0tvakdqeUpCdjZQUy8rS3NqL1h3T05Ja0JVaXNvRGI1?=
 =?utf-8?B?S21LTFBjaStKYXh2ZDB4RXQyTUMzejJ2Vmc3VGlCd3RONE1BY1dDRU1SUEIw?=
 =?utf-8?B?eldWZkJ1bTd3VDJHZzQ1T011Nzh0L2MvMVMxcGdIMzE0eWVBc3RxbDhJejJX?=
 =?utf-8?B?OFI4cTVkMzFMejJqOFRFWnYxdVV6anRucHAvSUFxcXVia21taWpEcTRUZkRW?=
 =?utf-8?B?MXNscXUxUTAycEJUbHQrTlFIcEIxdXBwRXArdGdzd0Q3TzBEWGhjeXZ1aFFC?=
 =?utf-8?B?Z1Ywcy9VVkxnVENVNDdCVEhXbkg3UVpnTkl0Sml1UjI5Rzd5S2IxTlNkRWdL?=
 =?utf-8?B?VUQvdU8xakk4VnJEMm92bVJGUzZIOHdXdlRrdlpHR2YrK2w4a20rUWUzQm9Y?=
 =?utf-8?B?Sk02S1JJZmZSTkhHSDYvWDJkNzVYTVhyWUgvNnpISVRneTlLa1R1c1V6WFR3?=
 =?utf-8?B?VTNxSnltMTRwcXFFd1liS21TRGVGaEg2bmt3UmdPaDdCYTcyVTRvZ1B2eW9z?=
 =?utf-8?B?Q0VaU05oV1FyUTBDUThRM2VlaWYvSWdhSFo4UEpJdVpMNDRpd2R4ckE1UkVq?=
 =?utf-8?B?UmRPUldiQkdvMmRNbHdGaGVOWUM5RldxWHNnbEZoZGY3Y0k2b3Myam5GUElI?=
 =?utf-8?B?NFhRN2lKd1RKNkp4MWxmZmtCTlFBMmZtUHlrTEJVRWFhVjRERjlYWnhLMU1E?=
 =?utf-8?B?eHRpdWprdjFaMTlyUHJFUGU5ZW9aa1RESjRXTFdXSk80ZXErRFJDdjNxRXBq?=
 =?utf-8?B?YmxnTWFmck9wNnpVYTUvK29PaHprNElEMVQ0QmNoRDdlWTFMa3ByVmNBYlRW?=
 =?utf-8?B?eHRhTDB2cXVvbVJZYzJBQ2JSd3U3bERSVjB3ZDMyOFBUVHNoeklGZ0FxbHBZ?=
 =?utf-8?B?SU9kaGphelhJTjN0NkFsWkplNUNlOTNCWWs4ZFNuc1NuVGlkemRjUWUxUEJC?=
 =?utf-8?B?d3R2SldVRFFpVWtTcFRZN0tPTTk4ODl0QUVvYWd5TVdubWFOZklmbE9NTlY3?=
 =?utf-8?B?R2o2NGhySmxidzc5Sm5vWmE2SWwwRWxITFpqL1cvbDUxWENTYWdhQ1pKZ0xG?=
 =?utf-8?B?L3dmaGJrcVVQVDVLb3krWnVyTFd6eHErMDc1eGJVWWlhSllucmMvY1JJL25t?=
 =?utf-8?B?a1Z3bUpWY3hVUHhRclhBTGtKVzUzd29ldjdNTExIYWpRK0tXRWZIQkc3VDhH?=
 =?utf-8?B?dXhvZzVZeHF2WU9wRk0wQkdpODU0eldiK1FQMmZxWWNPV0VaMFFqYzFacEx6?=
 =?utf-8?B?UExZNGRiWnJSVm9Icjg1WitFVkJINU5KUVBkdTZUcjVaL0E5WjIwdHFCdVFE?=
 =?utf-8?B?c1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21163f6d-f3f2-4d4f-ea45-08daac58ca5b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 13:50:58.1279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JuV5eopdtKl8a1OCA/xCuk30DQK4+PVWFXtRJAcaSpJhY7VljsLWq2+XAE/N3GwxUNQ/74BjhYMFxD3zZbAssBXAl11/agpv32xD1sUPwOM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_06,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210120091
X-Proofpoint-GUID: e4q0MCS0ZEsl6otCLZQd80tUATL3TKhs
X-Proofpoint-ORIG-GUID: e4q0MCS0ZEsl6otCLZQd80tUATL3TKhs
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2022 8:32 AM, Jason Gunthorpe wrote:
> On Tue, Oct 11, 2022 at 04:30:58PM -0400, Steven Sistare wrote:
>> On 10/11/2022 8:30 AM, Jason Gunthorpe wrote:
>>> On Mon, Oct 10, 2022 at 04:54:50PM -0400, Steven Sistare wrote:
>>>>> Do we have a solution to this?
>>>>>
>>>>> If not I would like to make a patch removing VFIO_DMA_UNMAP_FLAG_VADDR
>>>>>
>>>>> Aside from the approach to use the FD, another idea is to just use
>>>>> fork.
>>>>>
>>>>> qemu would do something like
>>>>>
>>>>>  .. stop all container ioctl activity ..
>>>>>  fork()
>>>>>     ioctl(CHANGE_MM) // switch all maps to this mm
>>>>>     .. signal parent.. 
>>>>>     .. wait parent..
>>>>>     exit(0)
>>>>>  .. wait child ..
>>>>>  exec()
>>>>>  ioctl(CHANGE_MM) // switch all maps to this mm
>>>>>  ..signal child..
>>>>>  waitpid(childpid)
>>>>>
>>>>> This way the kernel is never left without a page provider for the
>>>>> maps, the dummy mm_struct belonging to the fork will serve that role
>>>>> for the gap.
>>>>>
>>>>> And the above is only required if we have mdevs, so we could imagine
>>>>> userspace optimizing it away for, eg vfio-pci only cases.
>>>>>
>>>>> It is not as efficient as using a FD backing, but this is super easy
>>>>> to implement in the kernel.
>>>>
>>>> I propose to avoid deadlock for mediated devices as follows.  Currently, an
>>>> mdev calling vfio_pin_pages blocks in vfio_wait while VFIO_DMA_UNMAP_FLAG_VADDR
>>>> is asserted.
>>>>
>>>>   * In vfio_wait, I will maintain a list of waiters, each list element
>>>>     consisting of (task, mdev, close_flag=false).
>>>>
>>>>   * When the vfio device descriptor is closed, vfio_device_fops_release
>>>>     will notify the vfio_iommu driver, which will find the mdev on the waiters
>>>>     list, set elem->close_flag=true, and call wake_up_process for the task.
>>>
>>> This alone is not sufficient, the mdev driver can continue to
>>> establish new mappings until it's close_device function
>>> returns. Killing only existing mappings is racy.
>>>
>>> I think you are focusing on the one issue I pointed at, as I said, I'm
>>> sure there are more ways than just close to abuse this functionality
>>> to deadlock the kernel.
>>>
>>> I continue to prefer we remove it completely and do something more
>>> robust. I suggested two options.
>>
>> It's not racy.  New pin requests also land in vfio_wait if any vaddr's have
>> been invalidated in any vfio_dma in the iommu.  See
>>   vfio_iommu_type1_pin_pages()
>>     if (iommu->vaddr_invalid_count)
>>       vfio_find_dma_valid()
>>         vfio_wait()
> 
> I mean you can't do a one shot wakeup of only existing waiters, and
> you can't corrupt the container to wake up waiters for other devices,
> so I don't see how this can be made to work safely...
> 
> It also doesn't solve any flow that doesn't trigger file close, like a
> process thread being stuck on the wait in the kernel. eg because a
> trapped mmio triggered an access or something.
> 
> So it doesn't seem like a workable direction to me.
> 
>> However, I will investigate saving a reference to the file object in
>> the vfio_dma (for mappings backed by a file) and using that to
>> translate IOVA's.
> 
> It is certainly the best flow, but it may be difficult. Eg the memfd
> work for KVM to do something similar is quite involved.
> 
>> I think that will be easier to use than fork/CHANGE_MM/exec, and may
>> even be easier to use than VFIO_DMA_UNMAP_FLAG_VADDR.  To be
>> continued.
> 
> Yes, certainly easier to use, I suggested CHANGE_MM because the kernel
> implementation is very easy, I could send you something to test w/
> iommufd in a few hours effort probably.
> 
> Anyhow, I think this conversation has convinced me there is no way to
> fix VFIO_DMA_UNMAP_FLAG_VADDR. I'll send a patch reverting it due to
> it being a security bug, basically.

Please do not.  Please give me the courtesy of time to develop a replacement 
before we delete it. Surely you can make progress on other opens areas of iommufd
without needing to delete this immediately.

- Steve
