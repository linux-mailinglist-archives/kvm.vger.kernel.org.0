Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8D46602DE
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 16:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233380AbjAFPPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 10:15:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234520AbjAFPPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 10:15:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 568658B758
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 07:15:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 306APDK3017614;
        Fri, 6 Jan 2023 15:15:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=FlzHQxnTB8hDP6GvmTQkzVgO7IjMbZwK4WlbqtwJjXM=;
 b=LsJv6+3Op7N0isUF2ubvA/KdW1VnK3hnrJKxw6CoGHU14kuB7fH6Wq1D2ObPFPpWTMTH
 abFsFQnTz5F5lP7U09QhMqO0YNH87YxbLnqTalH+HILo3fqA09Bz3C1qaCJON9cjMCVX
 aep4oyv0B8DVPrvD3g+1iPs1QW5Z70ucCLFIYQxBgndPMx3PBGlTRjcA8hwQHFAF02e3
 Q0sPyOKX1ZEOMjTk1qxwPrNBof5f/97+nKypVzQssa4IEeHeodeF3lIuS8VsMbfXPBBl
 3+ndqK+W7ZsV0xFtNzDYEQEeG0pZ0OVXEnRyOm35O97OPzCPp2AxMGcjFJyCYhY74Bs7 5Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtbp13brq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 15:15:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 306Ec36T023369;
        Fri, 6 Jan 2023 15:15:01 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2044.outbound.protection.outlook.com [104.47.56.44])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwxkg9hp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Jan 2023 15:15:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdhvOBuS0zzoxoO4AJLyxv14YHRy4if2jS9PsEXhCyNcauqOVRqj2hfgcbsRBvwXXlFHpysLtL/yIRqlwzn4oTKqIFr5yVTd//L11pF/YfT2k62hbHrJ9NoaeNVP+ANy8MY2jJ/GElFJskUsDN3VSHr03X+rKNds3KkctDWgT4OxOhOm8eQlZPOsdtrbs1Ry+n0+JNP60lP+SXx5CcI9ZXBNbYqcIke78W7fmcDwlo8+C/dtlCKRPR7y9uEPrelp3No3KprUboaT8eS4RXpDN7wPkMwOUkrQz66axP9I8D01SYt3XmoGLEBZlVrS2UwIJJIzeVO4PPrm02VxOix0Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlzHQxnTB8hDP6GvmTQkzVgO7IjMbZwK4WlbqtwJjXM=;
 b=I1sBUca7EfgXpOGoOEA1CG9kCF3qklthzC5cTFglqYP6Yx4z8ezOaOENIsObgWqF83/AtGsyd5YNZyl6KAAkJhv3vMXFhlhOQeQsaJDtArHqMagFiPYdxd9EPTZDhL1KEKXnKMmZeoDLNcOis5FabwGgeHRHSx4io9ar95b8Tl3TRITBjl0l9qCv6wK/VdFzfjboffgDNKK3V1T7VZPywtD8GKBmUseq8XCTRMYjy2qPcV0jNTDm0TjFHGudemmtk8ZE8I/4Mi2Rv4I4+NLA2aJPvIuIZwQfDrCVRu6x2TdZFjOUlUQsnB396X2yZmaH1sDyw8BiQSmSLbYvPPZzJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlzHQxnTB8hDP6GvmTQkzVgO7IjMbZwK4WlbqtwJjXM=;
 b=WyZIIPByroenHmHDB5eQEiL2TxtSYIa+BmOMup43mPfGsnpAtaIckIInJJCixnSplKjCPDwauTVwKrs5TSb7Iz04OI5h84W6VlAcrF7mG3htBe6LGytNZ5JCRjh59vDP1AHiWCVdM0D+tqSe9EQFnX0zBYozH+2GRHlL0/SSvKI=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by PH7PR10MB6057.namprd10.prod.outlook.com (2603:10b6:510:1ff::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 15:14:59 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 15:14:59 +0000
Message-ID: <3ee416e7-f997-60b0-e35f-b610e974bb97@oracle.com>
Date:   Fri, 6 Jan 2023 10:14:57 -0500
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
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y7SAA6eJKK91F6rE@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR14CA0063.namprd14.prod.outlook.com
 (2603:10b6:5:18f::40) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|PH7PR10MB6057:EE_
X-MS-Office365-Filtering-Correlation-Id: baeeff90-06e0-4244-0a87-08daeff8c6cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJ/Pf+6udk9SJgc4aF3PvVCeSWa4AkX1Rblxg81kCbv1OQC2u27gdbqjGpzksFXcnxf7bvnpr7SKj5eR+IIWDt0NdHHtAabh3vCFVoTARc+h+xIWAJU9mEiFQ1np0bW4TiA0PZRsMMtH+HSheuSZg4+EZELeL0oDgpDXTLGuGNND5kuur73Q/DJsWjmetTEvB7USxkcae2jr+pg/hOen6k0iC1z8/ZjPU3iw2pYhMqSCQJ+Qlm+SYaFqsU1lCgG79qE+w4qXEVfPExidc0Wpop2hp0HGPI+SR2ggESAclwkU4taHeY7vJzPjZ4UxoeewfWgcrgtdeuFpDmN7qQP17dqYs8rGKhbBjOOVzhmn+wuJg1rKTFAaTOZnWDrIH5xmDGE/sYPtzarS67ovpA4Dkxk4soihbzEq8to2dcBsT/t1si6ejeob+oXRSO6aTFCBNrfqfzrHERGj0sk/gmUD/HarsqCIgtQmDMHAFxqKx6uHEnjpIKm7FwqC/9kD7JWzW1Z8o3y8EE20fwt94cWtnVRilKAN917S2wZHissuR1Pfm0FlVXrQLEbbDwbquCURcRNg4JE0FGJAjOM/jJB8Z7I3Z8N7gXrMDky9NwCe0PDVx8d9kIsN7nRzx9iIZTCpg6ZtaqvOPoDZQqIn1SETisbz+8rh99DPAvUgxRaBCs7X4A2zy081ZlVOciqF5PW8HGNydFVJZGu8gVhVy/twYMzeTxptFNzlPvediNOzCxE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199015)(6506007)(478600001)(53546011)(36756003)(6486002)(86362001)(31696002)(38100700002)(6512007)(36916002)(2616005)(186003)(26005)(83380400001)(66946007)(8676002)(8936002)(66556008)(5660300002)(66476007)(4326008)(44832011)(31686004)(316002)(2906002)(54906003)(41300700001)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmFqNVhDajQ4NVNmQTNkNGFoZ0xOYUZRUFQvRlFuVU9tNzFaMC8rdHE5Z0Uv?=
 =?utf-8?B?VFNXb2dFTUdqS00rbld4T1ZXNkhDcE9zSFlvSHZ6MndVUytCbnEyc0JRYlpM?=
 =?utf-8?B?RkFqSmY3T1VrUGY5SHV0NmlkK0pYbkQyemVLU2JGYlN1dU1JeUhia0F1SkZz?=
 =?utf-8?B?TzhLanZlRzBHcVJobnljdHRhcVJrK3hhYnJ2TGl4WCt5UkhKQ3Z5bUtET0tY?=
 =?utf-8?B?VHdKd28yRzBJKzJDYnFTcC9VRjczRnFxODhjWTZkbUwvQ2lwNDdYbUdWQlN4?=
 =?utf-8?B?Wkw3dVprWjlUVmlURjhibjVqSXRYZGZVOUZwTTFUSWhqcTRJSHkyWEV4Q0lj?=
 =?utf-8?B?ZGxDS3dJUHhXelRaMGxCL3JyV09neThLbFRjL05iRHNSWDV0bjFNOEhHTjlq?=
 =?utf-8?B?Wmowd2JPVjV1ZkNHNXJsenFGTDI0d2pOdEl2VldaYXB3SEdCcEM3STArOUdj?=
 =?utf-8?B?TytkSTlmTnpWaXhaTFZaTlYxeXNveUtrTFhnckY4dFhINkJEQ0lqMDhrRkhO?=
 =?utf-8?B?VC9Mc0o3Vjc1TncrYWNQZEN5VmJDbHBSRXpQTEd3M2kvRFo1Tmhacnp2Yzh2?=
 =?utf-8?B?UWFBdU5BTmtnSEVRRlVGMk1JVU9KNHRaNWprYTdhUG9IM1R2UVpHKzMvVmN2?=
 =?utf-8?B?Ni8wMDdOaUYya1ZxNTBjdGFGSi9CNTlha05jRG5yRXk0RnFTY2orSm1zeHFW?=
 =?utf-8?B?dXJPbkJuQlZlbmZJdDNkbHN4dmkvVittT0NiWWVNbUhLbnE4VjF0NXd3S1Uw?=
 =?utf-8?B?a1Z4VForVTI5ZTFiTjZCVk5JYXdWUG9OQmZqWmd2R05SQndyaktWeVVGcjFN?=
 =?utf-8?B?czROTDZxVVVHdDZ4MzJqOTlMNmlhRFRxblpxcWJlSWRGSC93UHMxdUJscGt4?=
 =?utf-8?B?UGpsMGxMQjVoRjVGUGE3WTFTcmZIZURVWVlMbmdiSHhHUHlzRXVkMGNxdDJi?=
 =?utf-8?B?WmlPenluK1ovWG5ua29xMHN3WmU2QmEwWEFaWXd0bU1nSWRRbENRWXI0V3RX?=
 =?utf-8?B?RFdjNi9FVEdPMUdWUE80eUtjT0lRN0FvbWs5UTVibWlLSWI1RFpKVkFjT05L?=
 =?utf-8?B?K21kdXAzcWNoeFhmNXZIL2p2d1RSdDl2czMxRmx3NVczUERwb1RJaEtaNFNL?=
 =?utf-8?B?V2VTL05MZTRPeGU4S3RiWnpyQ0VJalRpbmtBK3dkcXg2Tmw0ejVRcnlwY0Jp?=
 =?utf-8?B?MHN6TlVZVzdSUXNVNThjYkRRM3Rldnl2OVJqTENmY3l6Z25jdmZBWWNEUlFT?=
 =?utf-8?B?ZGRRWlFwQnFERGI4ZEQwQlBtUnQ5U2tqZm91a25FZm51eDRZTkVsWUZPekZZ?=
 =?utf-8?B?bzVRcGtmSHBiWXB2VjdLdnBYYUtmSEtWVjM1anAzWDlCL09MWkNhOE01eGdp?=
 =?utf-8?B?dmdYUytFeUhudVhQdlV4SFpLSk9MRlpHTHIwZ2FDSmhUdDBWaWMzNWJxeHlR?=
 =?utf-8?B?c0FRajZNbkl1VjNYU016U2xla1ZsZVk3STRyN3JINlU1YS81UGJER0xIQW03?=
 =?utf-8?B?RTQ1eUdtOGJuUzFIbkNnNDhQSkljVmJRLzlJSDlaOThMYWJsQXgrdVZoMWlv?=
 =?utf-8?B?UWVrQVE0UEJMQk5MWUZWMHBhQXJpVGt6VzBpNDlFanR6NFBsa01oalVNM3Vy?=
 =?utf-8?B?YW5yanV3TnBucmtIWVVydmd2a3JTTnZpdWp2RUduVElSQTBwdWs1bCtpWFZh?=
 =?utf-8?B?OTVDMnlaYjJRU2dJQ3UxQmVtQjNCZHpHTnIyWEdiM2pJQ2Zia3FZUkdDV25p?=
 =?utf-8?B?Zm9GSzFXaktrdmpKWUVyMjhxczZiRDZqMW12TlhVN21obGlMTWJ1MWJ6YmFz?=
 =?utf-8?B?a1F1alJCcXYva2paVzZib1IrQUI0S1ROZmlERnpzcVJOc014WUQ3NUxZZWM4?=
 =?utf-8?B?V2RVdW5DWWpGWU1weU9mSUVmOTRMelBiaGFsZGFlekxORTIxcTB0OTdFS2Rn?=
 =?utf-8?B?bU4yVVRBRzJhTjBubmxrTXdaY1BSUWdGcUdtWnlOSjBKN05GOUpFYUl4U3dB?=
 =?utf-8?B?amNlVG1UMkJoOW1uTzdzdlAzZk50bHBkdS9IYVNwUGFqalA3QURnN0pQdDFQ?=
 =?utf-8?B?eGxXYlJGZ2lJZDY3dWlPb3RKVGhqVmV3UHdDK28zWkozRkNicjVWaFpDb25t?=
 =?utf-8?B?OTMwLzlBOXhJR011RzBRVjNmK2NqN2E2OXo4WUpZUmRHbWw2ZUxHRVdXUnZG?=
 =?utf-8?B?MkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 59uxs/+vvQ9jtrBabUojjyc3uh8Mru/pLlDeaPSLZjV/1+YvMO/3osKkVi4HzmWu2op/v3NrMHY90nL+WrE0Zbf9Dr1vMIAiUOxuvQO+QhdbB8JHhnXXKMgVa3XnIMeUTUvwa+QL0Xk/WNvdlRbNMq/WGbo1CRPBRbw/gQ0Fp2WaS+B6hE0otwgc3OYgECIU8d+uLF+fvhjhsq3qUB2mS2JKK5IfpQ6KNh9Egiuy2WUPCESijkZ7y9gL4m+WP8FuxRAujUFGp2tQ3Eic6i8GiSURqkpEqpXePrkLHGiJBh9rziAxunbDWUxqDEFmYU+++JA3tSA+bOoaAGl7+ocBtxX6uCa5nd7Ih9MvuaQepzL+X7BeRUdgjx2401w9DOp6geY+EwqesyGLyH0uAur12a7D0k3n3a4jtQ9s4GBMzZrfUXndBV9s43kL7nZLhO18Z/Op+0PUxcnEyxZypgO5nw6PgwKLidMpEQ5aqzt//LHUtP3JksXxjecpcYR4X+3hawlTsOlX2fFanLXyzUOUAMRCxsyCaBD+i9L9H78oJ1qlOy5bHoaMv4a4QtLoMWhxQm2H/9n31T18a8L2d6FdaJgnV/JBrgPIRdHnp8j9G8dRa2qRPwq3TFzsGoXKACbUogD0I7Q9jgFEYlr9H1bq53H0SKA1C4I+0nsRSaFER6LYd7CRE9dxzetYMgTCka3MUwWMJ7lwbmMpW2YraFMU0dFQk1ZPZsiInnqcSR1mx7tXhLke/xvciZhMd3xJqu6d8uF/Se+oVCWN7s9snniCmYG1b5jtavuL3xojgzUWApXWGHK1qxo5C9QvL+i890ckC1IvOfx8vbg8f8IJv/zJ4AAzPg+MypEhIdfeh8fmf2vXP5YUriMmRJrFKrguG2PX
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: baeeff90-06e0-4244-0a87-08daeff8c6cb
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 15:14:59.4500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QhYWsYJNTEaFJOac20UgWndMIIq4HCEzjckaTi0XHw1fkXd8Pcg0lwSMcyYOS736ASjm7IqkLbIzmAiIe+uR0PmJ2ZyWwgxT50uCy7e6VOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6057
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-06_09,2023-01-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301060118
X-Proofpoint-GUID: 7rXCW-9pTBdt9P3SXpsazpIjfyAEmoQO
X-Proofpoint-ORIG-GUID: 7rXCW-9pTBdt9P3SXpsazpIjfyAEmoQO
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/2023 2:20 PM, Jason Gunthorpe wrote:
> On Tue, Jan 03, 2023 at 01:12:53PM -0500, Steven Sistare wrote:
>> On 1/3/2023 10:20 AM, Jason Gunthorpe wrote:
>>> On Tue, Dec 20, 2022 at 12:39:20PM -0800, Steve Sistare wrote:
>>>> When a vfio container is preserved across exec, the task does not change,
>>>> but it gets a new mm with locked_vm=0, and loses the count from existing
>>>> dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
>>>> to a large unsigned value, and a subsequent dma map request fails with
>>>> ENOMEM in __account_locked_vm.
>>>>
>>>> To avoid underflow, grab and save the mm at the time a dma is mapped.
>>>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
>>>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
>>>>
>>>> locked_vm is incremented for existing mappings in a subsequent patch.
>>>>
>>>> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>>>> ---
>>>>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
>>>>  1 file changed, 11 insertions(+), 16 deletions(-)
>>>>
>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>>>> index 144f5bb..71f980b 100644
>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>>>  	struct task_struct	*task;
>>>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>>>  	unsigned long		*bitmap;
>>>> +	struct mm_struct	*mm;
>>>>  };
>>>>  
>>>>  struct vfio_batch {
>>>> @@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>>>  	if (!npage)
>>>>  		return 0;
>>>>  
>>>> -	mm = async ? get_task_mm(dma->task) : dma->task->mm;
>>>> -	if (!mm)
>>>> +	mm = dma->mm;
>>>> +	if (async && !mmget_not_zero(mm))
>>>>  		return -ESRCH; /* process exited */
>>>
>>> Just delete the async, the lock_acct always acts on the dma which
>>> always has a singular mm.
>>>
>>> FIx the few callers that need it to do the mmget_no_zero() before
>>> calling in.
>>
>> Most of the callers pass async=true:
>>   ret = vfio_lock_acct(dma, lock_acct, false);
>>   vfio_lock_acct(dma, locked - unlocked, true);
>>   ret = vfio_lock_acct(dma, 1, true);
>>   vfio_lock_acct(dma, -unlocked, true);
>>   vfio_lock_acct(dma, -1, true);
>>   vfio_lock_acct(dma, -unlocked, true);
>>   ret = mm_lock_acct(task, mm, lock_cap, npage, false);
>>   mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage, true);
>>   vfio_lock_acct(dma, locked - unlocked, true);
> 
> Seems like if you make a lock_sub_acct() function that does the -1*
> and does the mmget it will be OK?

Do you mean, provide two versions of vfio_lock_acct?  Simplified:

    vfio_lock_acct()
    {
        mm_lock_acct()
        dma->locked_vm += npage;
    }

    vfio_lock_acct_async()
    {
        mmget_not_zero(dma->mm)

        mm_lock_acct()
        dma->locked_vm += npage;

        mmput(dma->mm);
    }

If so, I will factor this into a separate patch, since it is cosmetic, so stable
can omit it.

- Steve
