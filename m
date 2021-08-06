Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168A93E2640
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 10:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241278AbhHFIiw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 04:38:52 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:29666 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235933AbhHFIiu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Aug 2021 04:38:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1768b63O022192;
        Fri, 6 Aug 2021 08:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2021-07-09;
 bh=jlsax8F+ie7pesEK9OZbV/HelLBRQufnnfmRHQj7jd4=;
 b=y41gZ5DjX1cjoclEUp9j3j4D/OwRXMvB1RIAD0dq8h3RywqF9vAqyxaqipFgTp0PNbe+
 kgOqOisIohrLRVvUlqc1fOjdxSfHvgdL3iiIYFQ+2rkq0l3XcKpCE8agcnZwrZU6tbm+
 3MayLZuhVhIESyi68mcsZ2Of+GisAYQpFFDnNn1qHTXth8G9H9UWzm3ZPDqc9xZyCKkC
 ZWc2l5UGFITI9jCYhHizFYQc9Yy8s+ZGT/UUXhPKJ1CVA7UD7F4a0A36xtOE2jsNpH/P
 1Hn4a/j6bwLBtTpdqD6K0L+RGvB42/5JlltLUc42uc+s9a7Mvub4kjnczP7fAlcj2JKi aA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=jlsax8F+ie7pesEK9OZbV/HelLBRQufnnfmRHQj7jd4=;
 b=SZt4ObIpJu9Nc3jgmMdMvDo4KaTdQRRuVauHJtrpOew7MiSZbtA8fG/HweY0HueDfPOq
 HQoyXmSqvpuqK7/4Dd1krtkbkcN2+29EaYC+Wq4B6rWs+zk8dsjwQfUgILb74FP2gdcg
 EVkB/TRwzXjaJhHw1MNADJ+wMHUksw54rgoNiMWFN0aJQNVUUun61+z/qBR4wnli8v89
 eJeZ+SAtzoGbGTQgICrqfphOjAneM6C0Qcrsw6HSsRWKjAJn0lq7+ss47JKYXC6yFmEG
 SxyCdw4pWdOtlZFNTs+3rfoqxjGdKFk05snZbUwrkbG2ss6kqWHOHPQ60bOFW1DjPbK5 mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7wqv4ayu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 08:38:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1768c4Bj106844;
        Fri, 6 Aug 2021 08:38:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3a5ga1v78n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 08:38:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm2t+SWikFp0GIgHR8Cfpmo07hfys+SeixQ/TorxuG7SgdIvOcp5dnfBtKt/1bnv4TAfuxmbQ7DF/gfCS2sM62TSE2+/WMkLNkImCCWxw2iJff9PsRrCpv0Me7GmqaPLu7wy18JRuVfvaLJ6cjoZS2dBzLp+h6bFWItFUOA8kTJxjId3ru4fLNFaKq5xUcPkPXLwwUzJKeXIhaQdAVXLGRiMlHU+53i9zgP7+ShsV6q2TzfjRcumve46b+QP6Bw4vMQ7LCMIO11yVjNXb/kV0c37HBosDnJMGktVJ/OrFPC9nMWMJrOpHNfqAuS4qUoFLyN6aIO5OwMpbWsbuhAlYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlsax8F+ie7pesEK9OZbV/HelLBRQufnnfmRHQj7jd4=;
 b=Lqcx4Sf1riOHzi4dmLM2liUwwH1CVsuaAiWfnXRMzNh3psXDgK4GKicX65IS3pispDpJhGpiNK7Qcbue9iCIDgYwYouTHKI/zHxJMEn1eDV8KGsq42AWSKjJLhVHUt/VuDNKmfmla04qNNzcTSSS65hV6dRL0qTn3YlHOE8OmTx1PYWtLgIYPi7gfCWxa8Yj2KpU3dO7yCLBzl81C4Dl+FL48NG5P26E/L5Q4yLe1qv3ILSZ2AjCgoJmpOb4OwUjUbA6FGbpCgQsFflgA8JmDHiMhuS/Vyfs4QBQyGCaYc345QIUzsi2Ua1F0IYgMjWkpTgVCF26vNjRu+Fs3NcixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlsax8F+ie7pesEK9OZbV/HelLBRQufnnfmRHQj7jd4=;
 b=QfBH5ZLi1+2uNFetkx56NT7OdUvsW3C4PbX8iFbrLvPr5cOolb140WTkHHHhYhFf7wlTjW68Xcy6aerhzxMBJHiNNxO1cfNJwVRrfR7bpej4dBg69R/UcDLsJPfufZWrhr1jJWpjjC9piiZP770m6IK4Xa7mfCMDUhM33noo1TU=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR1001MB2205.namprd10.prod.outlook.com
 (2603:10b6:301:2d::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Fri, 6 Aug
 2021 08:36:07 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4394.019; Fri, 6 Aug 2021
 08:36:07 +0000
Date:   Fri, 6 Aug 2021 11:35:49 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joerg Roedel <jroedel@suse.de>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] x86/sev: Split up runtime #VC handler for correct
 state tracking
Message-ID: <20210806083549.GM22532@kadam>
References: <20210804095725.GA8011@kili>
 <YQqKS7ayK1qkmNzv@suse.de>
 <20210804125834.GF22532@kadam>
 <YQqi3lKFmR7g/kIl@suse.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQqi3lKFmR7g/kIl@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNXP275CA0020.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::32)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JNXP275CA0020.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:19::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Fri, 6 Aug 2021 08:36:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd81fe17-3352-4d50-8914-08d958b53bef
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2205:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2205411F576E28F4311B93DE8EF39@MWHPR1001MB2205.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: olP2SPrVhP6Mqip0g6wGYh0clA61SNWRqwrtKp0FxKQWzo4I3kavpkblq2rvxNYg8j30jE9SLxHrRZ4pccDN83JYZWUI2fRqoG8nx+IQOr99hm5wfA0QioR5k/aqlRS7r4doKAi68VPn1pTyPvNPfNZtqDMeCnAO9gTmfppOX2GU2k+UG0PLnWN5yveF/vTG6Jar8Hn1g/jx4xQndccx9+mZBCqZJ2KMQM4LObEFzgawuYhd+XVgdXP37ZXILTNF2qAZntk16kQXiPP5v3RXaOrwwF3JIOQVGi77w05ivQXRgFnfHai49FvrYTp/0JcZ5KxVWDS7xH0ygvVCa49LeKKCvhXJwsySLVTOk7Mv2tL7q+8if1+pTzKEvzPFmqmYNtoQrZ9J27wkvXdY9jBiEwPZms4aFt23LD2TgsD5/baZVIVic+jve+2yjL4cqqswcufvZT46ik2VzRPH8Nsf8hQA5ACyPzSP2kypgM6FM0+z7uNb1mFiu8r9n3osjuQxA9i/aMA6pztwHMu48KLQjMXXk6lRwMWoXAyM6wQvmzer5YGQg+H2ZcEuD/WL1RP2p9x3L8QCgJQjkbhGorHCZzESp3aUhHy7ACFgHDc56e7rDTpk6mZZJQbl5qHvKdKbZoyrfOTw5uT6nolU6GyrDEmrdQS8eVT4gjQEn1RtF1Bqd5bdJYnatKrork6ttFxB9afYGvcN2hJx06+iUQwLoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(44832011)(26005)(66946007)(8936002)(66556008)(4326008)(2906002)(8676002)(6916009)(83380400001)(9686003)(5660300002)(1076003)(66476007)(55016002)(38100700002)(38350700002)(33716001)(86362001)(186003)(6666004)(33656002)(508600001)(316002)(52116002)(9576002)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pOkT2/lChcc1e8qUpVk8QnExZuLv2zES2PHI/vhnTJO/mhReyiiEQ07MlsNd?=
 =?us-ascii?Q?gGFMMVu8FzNVmtQZ1VFbeJrnVwh6cx86O6Dvw76kl2nkZNWxgwS37po7ugbU?=
 =?us-ascii?Q?52ExRxnY0ukm2sBGFLsaYpLimj72NrSrF4XGn0BVvRDAKvVD5mryhcFnxW7y?=
 =?us-ascii?Q?VkpSKvx4VW+D5awylzKH4Hs7U888ZYEMfHbaxk9ZUsZVBkjvyleH++nj2o+5?=
 =?us-ascii?Q?a8Al8h5yVkcB4An6i4lfVq+TW9U0/oo7vg8pcxxmQaT129huIdlsN56ksSAu?=
 =?us-ascii?Q?yk1V6fJ34BtwaCUdt23pKGPuC9/SSj+EXRcVev9VRG3ATRfHUhPH8AVIjOYe?=
 =?us-ascii?Q?PPO83AVhg85Ytj7Qg+JQXy+bOO5Wue7TleLdJU0mL8KNeG5346kE/GnR0ka4?=
 =?us-ascii?Q?XLTsgcU/IDRDCtYSwM9gMwwl1WsJyAqUMWjRPvhxhsJz0JbzQu853V1vbnLw?=
 =?us-ascii?Q?pCLwTTubnPYsYzQmsc+TtT2mJ0nlfJjrfk2iFVyHHbh329SbGKHCu0mh9YMe?=
 =?us-ascii?Q?0n6p2Q+RnY4S/pCl7qgboNmgGZhGtVGoIofWkxhzKLqE0BoGm/cVlUS4VyQC?=
 =?us-ascii?Q?GKNPhr2JMHyTjbMVdXQyhR1twuRp14/K9fInF5XdySScUXEtGwIijdzfwrhK?=
 =?us-ascii?Q?pzmlQXstnf0dAOri+6fLi+VTPAPPpO3qT3s71OQZHgeNXzeYp8lodk9Gyfcm?=
 =?us-ascii?Q?JYoyXBYrr3lWjPj8/zswehcE07aTW5m5fajpWZ15UgscOnNgXxAQDtwuF5Sf?=
 =?us-ascii?Q?Te9WkpSxDbjnD6a9aypwUkfQuD3K41THNynN0RYCr6gYCf9ZvYvE56pHWv5V?=
 =?us-ascii?Q?/s0dZAHym3CBc8My/XYhYleRL3lTjF8L5pNJOsf/vvpKC1ZW87eF6ze1R98s?=
 =?us-ascii?Q?V3Pctb3oPEh+0VL/NKUQBE8ozz0iPG04Ks9bmAtPNZwwFCHYOCNx5TC5QbOn?=
 =?us-ascii?Q?Ixmrgn2OIg2UADeQGVndsvgvonfbVn1+7swqzL4LIEXvL15RRAgdvRtvNHHH?=
 =?us-ascii?Q?Xi1dFlYJseVR5M1LHfppPBlcSNMVEatD26Dq1gzLFEhhHVTYg3zXgEILvYK6?=
 =?us-ascii?Q?UqjR97/+n/4VyTwtOF/0YTefXfP9ooJmg9o9hPTobw0y2L3PGymkfmqxPs6I?=
 =?us-ascii?Q?9PXQO9F+ewYYARNYkwYENx39zXrgJbt6dCOfewova9tOji1nMiDTdD8EZlAW?=
 =?us-ascii?Q?zbC40BM3LubNjwJYHPn5Lw/7JJ9tUOPnwN2JyvkSpF8zTR9IQVK9z7weQNtE?=
 =?us-ascii?Q?rkZ1pkkMRPRKbTGfCKVMThSQ5rdt8hSJ4d/D7jEHtX04cgmBfNcw1ELcVJ/u?=
 =?us-ascii?Q?1+6I5vlDwFg8Sl1kUoDH7KsO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd81fe17-3352-4d50-8914-08d958b53bef
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 08:36:07.0682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrU3wSzQt3NFl/62XeQwV4n4lBcpbKLevTJvCrtP9ZeUbjfvqfKUACvbZZKqD1nMG/Zs6uzrlqc3NPo0dAnjOVtP51WZoQFB83ez4QvyKQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2205
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060060
X-Proofpoint-GUID: ZUM-4A5gHgNzpA10BD2WH8M52QFBASTM
X-Proofpoint-ORIG-GUID: ZUM-4A5gHgNzpA10BD2WH8M52QFBASTM
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 04:23:26PM +0200, Joerg Roedel wrote:
> On Wed, Aug 04, 2021 at 03:58:34PM +0300, Dan Carpenter wrote:
> > exc_page_fault() <-- called with preempt disabled
> > --> kvm_handle_async_pf()
> >     --> __kvm_handle_async_pf()
> >         --> kvm_async_pf_task_wait_schedule() calls schedule().
> 
> This call path can not be taken in the page-fault handler when called
> from the #VC handler. To take this path the host needs to inject an
> async page-fault, especially setting async pf flags, without injecting a
> page-fault exception on its own ... and when the #VC handler is running.
> KVM is not doing that.
> 
> Okay, the hypervisor can be malicious, but otherwise this can't happen.
> To mitigate a malicious hypervisor threat here it might be a solution to
> not call the page-fault handler directly from the #VC handler and let it
> re-fault after the #VC handler returned.
> 

Thanks for taking a look at this.

Also it turns out that my check wasn't taking in_atomic() into
consideration either so I've added that.

regards,
dan carpenter

