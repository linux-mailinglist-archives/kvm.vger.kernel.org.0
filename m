Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C354C662A97
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbjAIPyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 10:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbjAIPyj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 10:54:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E73108E
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 07:54:37 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309FQdAu023750;
        Mon, 9 Jan 2023 15:54:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fPAlOGpLlewnynssfEZDGgUUECCeMl+PjjJslBKWk28=;
 b=00q7TBdjasyQ9f+vlGmIPRsEQAdSPZxhE8duradEQ5HLdUoq7y2V5zfOLCyBLHt/FC/W
 5Q2MVMm6l5Hy8/XjrIMyUGdD+tSnmZZ5rpV66oMzr/bXQMMpxkpt/xfpfaar1Yg9l7MP
 Ww58uqPUFjcPV3nbsVQUsdHpYepe2dwG1BZqUIILHMJewZ62DxiA8+pEWIl0Pa2pJpIN
 ksVJe2r1E1phsI8ZKeExUu90aVYo/8VH7L/x50VhaAgM3JnD8CvJllvAAblN8AZbPWkj
 0Wj7YZgraMsHocRk2MgpcoE5oyEtgMi1ihsBNJYgtg8zeJRVJdCfsjreHeg8BR82d0v2 tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3my0btjxw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 15:54:30 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309FWRii033127;
        Mon, 9 Jan 2023 15:54:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mxy6457ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 15:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIHr6eMcw4n/gnHov2G3dvqvMO8M9If7Ho8KBsr3NykpWZpUm2jgtfYY5Kdl/jse7+kkQ06BjT/Sm6d7u5x6RfC/J8ZgPGYIoPjwWftjrnep/NX0J0c422dUh5OpfQU7fljx5waKnCuRvNWhBjCGbzluKbm6Ooa7wEAds+Uv1R7xtmJCAQCwrjoNbD6y5vKD05jDASZXIHOwxAwwlOPGxNgkLAypfRVtpXCXWROJ9ziF+5WgYUd/wURTUPOCHBDS2gKwRc2y5woT2j+yQ3SVvVm0L5scD8uksgGKkykAjBtY5fzDYMYo5KORy78AVo0Dfb+fgnMfJUZW9Sz5Gzqieg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fPAlOGpLlewnynssfEZDGgUUECCeMl+PjjJslBKWk28=;
 b=mFSNb2gqQ9fRKwcf2zWKmkBDjBrpzgWc3cUPHP757dkLc1huXWKwRpXVUONiPYiUl9fTjEVY4jSU4/NixilItgEUWNjYvrhdGcyT/P5yYtDZe3W7y6czuUIgTt978i7ocknoUW407OKEwgBoaP+oKHYA8GHNAcrU/hy+1Mmni7JXzyZGiKPTaCNR+Q4AuUsGTajia/8FwogEywpxLVbY/vh7UuUXA/eefJgJCcrx+fXm7+ZvqmkdJb5+xHzPAk6J1JwUxiixxGIzMkuoKydq0gFva39HvyxQ5LSari9se4RR/5zBlWlKgb6PwMHikHCUgyIbQHtxIq8z/+cJnxO5DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fPAlOGpLlewnynssfEZDGgUUECCeMl+PjjJslBKWk28=;
 b=paa4cqG27Esudq4IRsc0SlPs2AgClHp0+hxjy2W6QHwOBv4BxhZM6vFgYS79/uC0D7sw5uadQirglDfHPakb6e9gOB3Q3DIZqyDYmD/UWcnjAbjtBF7zAETWZ6iifWeIN5O9nE+F3DGqAzLdkNqiO3rUfkJHaZOPYxNQFDdwsp4=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by CH2PR10MB4134.namprd10.prod.outlook.com (2603:10b6:610:a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.11; Mon, 9 Jan
 2023 15:54:27 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 15:54:27 +0000
Message-ID: <25717799-7683-c39b-354c-0f6f6ff11635@oracle.com>
Date:   Mon, 9 Jan 2023 10:54:24 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V7 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
 <Y7RHtRnHOcrBuxBi@nvidia.com>
 <61e24891-28a6-8012-c2c3-f90f9c81c1c0@oracle.com>
 <Y7SAA6eJKK91F6rE@nvidia.com>
 <3ee416e7-f997-60b0-e35f-b610e974bb97@oracle.com>
 <Y7wcHg0d0ebC6h+3@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y7wcHg0d0ebC6h+3@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:806:2d3::15) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|CH2PR10MB4134:EE_
X-MS-Office365-Filtering-Correlation-Id: fddffc91-ba05-45c6-78df-08daf259c95f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a95eCAFsu+4x802C1M0h+3UdizwRH8BC7PsS/AoAebemdj315El/xy7bnwdHPE9efeijrwJD775SAyPiKDjYfr3panNKv5mP62G5H8Btm3yjElzUaFiInLmbqR9aofHXkTSKAZuDCWCEo3pbgXGWVQzYeS4SZ1ySC6DVwJ2iABWZxjm2cmLRlLsPDdg3KhTwOirw/sEeujNj3SZz6FPtvTRCaiCPAWCCE0JBuOm7kZoAMFxJPXHQJQv5LMpcJvzp3WhV9Serr8o4srapZYmBVe4glZ0ovMJfI7rm699L6PBoW6lq/T5xCngQD8Q09gW6a2tCiaTc8Tz2uEgqko5FVFOwfWr5pivoTmd1ju3xRjvDGpp6f1PZrfGId0+4S2hpAxdlRBdwF3DwHhf7Vb0yOxF4Z1+0Qk8KZDOeLKsfG+SiGlXRrsKDubg72YS2Q9ZbZ7n9B40zPEzDyhq0erVNPkp53TfHjpK9ag0eoZM0ZgqJJDLKZF4XN/gEOsNtrw2J/auhMW2hBOZHtHwIO8WCJh55sqneIXqdOmO9h2eTcCKuU8zHu42vzHB+aJzB0mfGY51rclU2PGi7WhNv5QlxZglGTzH1RU/7l851ScFj3jTrF+3eYNADO2hLYvm5VYBYjekF2jcIui5j9bXGD6onWeVznFtsVNzZSYEix2S3N3vXBxvxEki7+5qH8POROoOhUHizsVqcIeyz+yb2G7E29En4sUYARZEA1tPCJ+whnn0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(366004)(396003)(451199015)(83380400001)(36916002)(6486002)(36756003)(53546011)(6506007)(6666004)(478600001)(316002)(4326008)(6916009)(8676002)(86362001)(66946007)(31696002)(66556008)(66476007)(41300700001)(5660300002)(44832011)(38100700002)(8936002)(54906003)(2616005)(31686004)(6512007)(26005)(186003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTgwSUdCUmpCeHhGQStHb2xseDc5U0RwR3czVC90SFlhcmV3d1dISEpRZjBj?=
 =?utf-8?B?U0FWcmhDMkM5RTRORTFvcHIrVlBMaWNuNDIzN1RncE1wOEFrVW1JZ0xQT0Ny?=
 =?utf-8?B?QXhMUitFSS93dmRNMytIS080NUVjK0VodFhmNE5WUTB3QmtxYW9yL3hXQUJG?=
 =?utf-8?B?YWpaemhqelNtbWxVY0t5aVZBQVFnQWdjSFJQSm0vMklJSk1vYmRscWZwOGVT?=
 =?utf-8?B?MUFoeWE2MEJnK3p4cWJta2plTkJiRG9WRjc4eEVqWFh4STlIeTc4WkJtNzVp?=
 =?utf-8?B?WFVMbFBjSUswQUlLMS8zeFV6YjN4ZzJBU2xWSXVzejRiWFRrYWh0TVBWeWlr?=
 =?utf-8?B?TWpKSjJpcjlxOHN2dnpZY2d5QUtZRjF5YTBjVWVNRDRBL3hVRGNDcUpTeldy?=
 =?utf-8?B?NXpYbVh3eWM3Q2V2b1BMTGFxTGRvTEdaZVJ4V3N3TVJjOUtzVVphZHpyZ3JI?=
 =?utf-8?B?S21sb1E5UVowMU5BOEphcVF6bWh5dG5kQyt1dnBrak01QzFQTW0wMXhMU3J0?=
 =?utf-8?B?ZXhKSTF2U3dpalM5aGZZU2dVR2pLU2NJM1RvOVpSeitGdUhjSXhaaFhUSzdQ?=
 =?utf-8?B?TiswZHNtOFkzOGNIYzFvKzI0QVMwcENSaGZQMEZzYjdtT3paVVN3dkxFQ2dL?=
 =?utf-8?B?NjlSWkRKc3RBUWowMlEyM3g0eEZDK0xTODlDOHZiQmFNUUlab2p1RExmbkpG?=
 =?utf-8?B?WTJieEtGWmMyMkZEVW1MZTQvTkl6alpFalVuWUZpeVMvVkNTVk12cE56MU1G?=
 =?utf-8?B?a0o1eDZ6Z01MMXUzTjExYlFRdmZEOUtDdWJvS3ZuYVJNT1pPS25RcE85SDFD?=
 =?utf-8?B?N25Fc0s3cnVkb0E2OHg2emV4eXc5amE4VkdpdmVSb0tLVlFmQmNpRkhsZXZ5?=
 =?utf-8?B?NERSaTZ5TWx0WTNkWk9lanBodmVYU3NqbGh6QzZOVFEvaW0weFlkSTZDTmcr?=
 =?utf-8?B?WklrNnEwUEI2dGx2WjdtRjlFVWtORm1Yc1JMR2lCalI2UG4zVXlSS1pycDVu?=
 =?utf-8?B?ZEUrZHVkd1lpV2pUL1U4cHJEelBlRUtrN1Q5N0dKR1FqcUVyUSs2SnVJdzMy?=
 =?utf-8?B?MG9DaWtIOGdkRVBMd00yK2FvOXZpTm1vT3NzTnoxdHJNZGdVYUc3MUF3eHIv?=
 =?utf-8?B?RTF2UFVXdUJiREVtOTFBN0ZTSFdHSFVzMTdqTnhEcGNvRkxRbFlTNFVRYkdj?=
 =?utf-8?B?enN3Tk54eU5udjZKa1VPeUFDUFAxWTlBR0ZGUFZzaGxhMS84QTFvNWxhU0VX?=
 =?utf-8?B?cDNCZUVoeTNNM0NkaTFuU201L0RhVE16WFNoTDdFTVQ4TGtnQUVSVFgwNytx?=
 =?utf-8?B?L3pFMTZOWEsxb1A2TTIwR1BGTGlZdlNJMzIxeHQ2ZEVTSTZneUpJYTVtN2sr?=
 =?utf-8?B?SzY1a09qcFg1elZieTdQNStCdFhXVEJBY1pnb2I0cE5Zb21BTFdXVXArd2V6?=
 =?utf-8?B?aHVLRGk4UndYUmdLOU9Md25pdGdzbWMzUFlGVFFMN2hNRUExTC9DVjJPNTdQ?=
 =?utf-8?B?M0ZLeVFHQjFncDdSbW0xbElvakFxc0ltQW5ZamhMSUk3SlB6ODJweHl1KzFj?=
 =?utf-8?B?eEp5QkV0ZXo3S011b3NlM2JJSC9LbUIrY3ducXFobTBTUTQvOXZROHF0M0U5?=
 =?utf-8?B?MHhKYnpTeDNpMU1adk8yVUR5ZlNjMVo2RFVxTE5semdFc2M5dEpta3RZKzVF?=
 =?utf-8?B?WXUxYW0yU0VmRnorMEM4MTQ5SXQvMjFmSjd2WDJaa3J1RFE3VTZ0cHQxOGVu?=
 =?utf-8?B?U0N5ZDFxQkRydWxGRW53djQ0MFFwa1J5RTNGbWlFWWtaeDZEbTRiMC9iY0kv?=
 =?utf-8?B?dHFVQzQ3VDRQWXlzM0ZSOFVuUThqdkt2cSsxSUNCUHAveWhTWXFScFhWdjQ0?=
 =?utf-8?B?dFZJanlYcWd5S2VNTU9zYjZheThIOGZKam9uMVpEcGg1UWtQN2JEbXV5QUtN?=
 =?utf-8?B?eWh6aHRaSVJPd2ZOWGN0RjBOcTJIaFdjaUVjZ3hKMWlBaGFHSFF5ZUl0cVVl?=
 =?utf-8?B?NGllU2ZxeFkySVF5WG5VWDJPblFuSzJuZjFkY3pWTUpIcVlnQWNuMm9mRENQ?=
 =?utf-8?B?dmtSRzR0eVpKNmVFdm55RTc2cGFwQ3pFN3BMdDFSNDIyK1c4QzRPYmxDZVpy?=
 =?utf-8?B?Q296MWVnY1NMU01DbDNqTDdKcWNEb0U0aWhvME5QaTBvVW4rWDR5a285OUc5?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HHiU+mXYssjbmYaoq/kWUDfH5K8f0wDq36jRHc2Q08MhrL2iD0fC/FVB22bIxMVuJNWslhi8VEp1+8qjB5GLkYW113yrUv231U/DzF26hWVEv32x/kn1zSX6df9Me4duXdO+H3x3B6zt1WOTnQPf9YPoJSljXq5TIRPKb/Tu93v/nESSFzr5rw2jaGcCkehAz2wRnxE8RmVEz7m2rnibzmzL/VMqWVhnOPDJVXV+6KEuqwCi3xcnsdJlszLiitLBlLivGAF/p+05Ckb4tWYRYcmYjpmC0s1DUlF9sCaqRzvehHA7YHDNWHnDbEHpr1KbehztfzKkUH4FnghWNejFpsonVj2Cz9RmWRtySbpectc1sOkzp9B54gyJX1IenC+5R5HdH7SHVv5dw2g59OwPqy2d1V402buiqpx6iy0r2sXtZKZwqvHApu0WcSBKDZcadwZERN/pwsQuwn+ZfqlN1UJiKXFCtR2RQ04r8BdvGgfXKGuNTacnDGx7slXwxvT+kN8IBGC+pJZ8ppc9CIevX2ypZgd38gLvXgwLFNLKSQTBePH1WFq9y1qnxogrNzQ/xJnrrI/7oLs5GD383NWFHem6Hs5QM3W5Q5iBsku/sJIxSAmf/3wtywXncLLX79VgqyOxGQUqArFr16zipaz9gGeWRFofJJL5dZ44PgWQuCgnd7j3leyKGCcx1bYOQn88Tqs4wDZw3+5I2Zy36cG0lhKZCpu1dBAvqy6cFay7bWq3A3KAA1IurAEel6beyqzG0T9aJyz6c/QJx6ULxzZfkPYvgxL1bY8M1G3GmxtMTuWrO0wrMC0tmMR7gFqc87YPdKy9DiTqKI+KdtWqA59ILw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddffc91-ba05-45c6-78df-08daf259c95f
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 15:54:27.2397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WFGE+0vvjNwXdGyBK8Hs25CzuKAs8s8yBxFKV2T+vk88+I4L2R9QU7I9SMspymjxA2C2gZmpn4+vY9XaXubWkdYzMFv6GtEyEI/8rXActP8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4134
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_10,2023-01-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090115
X-Proofpoint-GUID: Xveo4JCEcAV0EziaSmDelSljRbVRbvoM
X-Proofpoint-ORIG-GUID: Xveo4JCEcAV0EziaSmDelSljRbVRbvoM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/2023 8:52 AM, Jason Gunthorpe wrote:
> On Fri, Jan 06, 2023 at 10:14:57AM -0500, Steven Sistare wrote:
>> On 1/3/2023 2:20 PM, Jason Gunthorpe wrote:
>>> On Tue, Jan 03, 2023 at 01:12:53PM -0500, Steven Sistare wrote:
>>>> On 1/3/2023 10:20 AM, Jason Gunthorpe wrote:
>>>>> On Tue, Dec 20, 2022 at 12:39:20PM -0800, Steve Sistare wrote:
>>>>>> When a vfio container is preserved across exec, the task does not change,
>>>>>> but it gets a new mm with locked_vm=0, and loses the count from existing
>>>>>> dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
>>>>>> to a large unsigned value, and a subsequent dma map request fails with
>>>>>> ENOMEM in __account_locked_vm.
>>>>>>
>>>>>> To avoid underflow, grab and save the mm at the time a dma is mapped.
>>>>>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
>>>>>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
>>>>>>
>>>>>> locked_vm is incremented for existing mappings in a subsequent patch.
>>>>>>
>>>>>> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>>>>> ---
>>>>>>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
>>>>>>  1 file changed, 11 insertions(+), 16 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>>>> index 144f5bb..71f980b 100644
>>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>>>>>  	struct task_struct	*task;
>>>>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>>>>  	unsigned long		*bitmap;
>>>>>> +	struct mm_struct	*mm;
>>>>>>  };
>>>>>>  
>>>>>>  struct vfio_batch {
>>>>>> @@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>>>>>  	if (!npage)
>>>>>>  		return 0;
>>>>>>  
>>>>>> -	mm = async ? get_task_mm(dma->task) : dma->task->mm;
>>>>>> -	if (!mm)
>>>>>> +	mm = dma->mm;
>>>>>> +	if (async && !mmget_not_zero(mm))
>>>>>>  		return -ESRCH; /* process exited */
>>>>>
>>>>> Just delete the async, the lock_acct always acts on the dma which
>>>>> always has a singular mm.
>>>>>
>>>>> FIx the few callers that need it to do the mmget_no_zero() before
>>>>> calling in.
>>>>
>>>> Most of the callers pass async=true:
>>>>   ret = vfio_lock_acct(dma, lock_acct, false);
>>>>   vfio_lock_acct(dma, locked - unlocked, true);
>>>>   ret = vfio_lock_acct(dma, 1, true);
>>>>   vfio_lock_acct(dma, -unlocked, true);
>>>>   vfio_lock_acct(dma, -1, true);
>>>>   vfio_lock_acct(dma, -unlocked, true);
>>>>   ret = mm_lock_acct(task, mm, lock_cap, npage, false);
>>>>   mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage, true);
>>>>   vfio_lock_acct(dma, locked - unlocked, true);
>>>
>>> Seems like if you make a lock_sub_acct() function that does the -1*
>>> and does the mmget it will be OK?
>>
>> Do you mean, provide two versions of vfio_lock_acct?  Simplified:
>>
>>     vfio_lock_acct()
>>     {
>>         mm_lock_acct()
>>         dma->locked_vm += npage;
>>     }
>>
>>     vfio_lock_acct_async()
>>     {
>>         mmget_not_zero(dma->mm)
>>
>>         mm_lock_acct()
>>         dma->locked_vm += npage;
>>
>>         mmput(dma->mm);
>>     }
> 
> I was thinking more like 
> 
> ()
>        mmget_not_zero(dma->mm)
> 	 mm->locked_vm -= npage 
         ^^^^^^
Is this shorthand for open coding __account_locked_vm?  If so, we are
essentially saying the same thing.  My function vfio_lock_acct_async calls 
mm_lock_acct which calls __account_locked_vm.

But, your vfio_lock_acct_subtract does not call mmput, so maybe I still don't
grok your suggestion.

FWIW here are my functions with all error checking:

static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
                        bool lock_cap, long npage)
{
        int ret = mmap_write_lock_killable(mm);

        if (!ret) {
                ret = __account_locked_vm(mm, abs(npage), npage > 0, task,
                                          lock_cap);
                mmap_write_unlock(mm);
        }

        return ret;
}

static int vfio_lock_acct(struct vfio_dma *dma, long npage)
{
        int ret;

        if (!npage)
                return 0;

        ret = mm_lock_acct(dma->task, dma->mm, dma->lock_cap, npage);
        if (!ret)
                dma->locked_vm += npage;

        return ret;
}

static int vfio_lock_acct_async(struct vfio_dma *dma, long npage)
{
        int ret;

        if (!npage)
                return 0;

        if (!mmget_not_zero(dma->mm))
                return -ESRCH; /* process exited */

        ret = mm_lock_acct(dma->task, dma->mm, dma->lock_cap, npage);
        if (!ret)
                dma->locked_vm += npage;

        mmput(dma->mm);

        return ret;
}

- Steve
