Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2A3313E3B
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 19:57:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234488AbhBHS5O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 13:57:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38570 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbhBHS4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 13:56:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118Ifw8B139351;
        Mon, 8 Feb 2021 18:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=CjMxEAJKNbjARVHQkm/7oG/AsLILH/SPz0CLYUBb484=;
 b=V1QGOlsKRSYwscZY1h6vXV6lyT07Y8HfSwAOtqoKe6E6zbHL9spJaVBm9UJhJwFzn5nG
 52sycDLj60sDXnGEZOxdUnTa6vcByZdrvaEwwb/a0RdHKgM5YSzgsXzaiWxne2Npjf31
 oqFlHWy8Yw+90qJ1fUvOYfekSU+tKHGTtqfYvFmvz5vFgifH/B9yR+Q1JknLK/S6M14z
 EcZwdLbe/nmY0yyPno1Qw4uCM5PqGlqMwJMXv6xbHtGvzh6U1G8kCOYB2IuhgILrKdek
 RiQF52F1nWj8QvovHk+tR0JZUbiCmajlX+2CsJmmhxkZiYK8H8nCeEX052oOJsGgK+DR pQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36hkrmvxr3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 18:55:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 118Iea9O193979;
        Mon, 8 Feb 2021 18:55:32 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by userp3020.oracle.com with ESMTP id 36j4vq9rhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Feb 2021 18:55:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxBBInO0mW7mw5Hu6QshgUjvTYlQ6x6zQuOR8rBs/mI32ZHwXfE7FdUDY9fPc6y7xEseRCF7JXhQjguy6RGZCuUDcTbVgePKnthtMk5ZhwZh0shbZlX7o7OLslySihKD9s2S7lmdVdA+5E+qQvo7Vr7+IauegniKkYoHpW1ZcNrGhSXlmWL7pioOCmbKUKeBGDrlGvluHMOCpu2VhRHapsPL7gYGXXqhRnGBNNa3B2d3qDVIQryHxJ8cE6a/Uy2jtehGzuj64+nuLyXVjevICH6rApYVPa+KOU2lj+p+nJ3QO1PG9RHfBEyBNV/bSjZrKyfsdCfrvcZBFN6zD1hCbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjMxEAJKNbjARVHQkm/7oG/AsLILH/SPz0CLYUBb484=;
 b=QHNQ66wyYLCG4pM0ai2Sb13+ueJNAgwVLzSnIQuC0PXvHTGSQJCM5ZcXzE8PQJzEss9SAc4e3KvlibFyfPiysMAV6PYMihjn9w451kEKpnfzNmZ7yzoXWD4M5pDKRrL27ATqO/YrUGHHRM2Qlatk8kxUyC5EMu5AFrnbfiOP5ilfur3C2hLi2EjpMsWPtI+bPN5DIOIw4jRlhUdnGK5I4DQuy0wTZ5S1eKTSWnNoLtr50XJ1qnSoDmDs1rJ+riKd08OSe/L4giGva8spGeI7jkfEDRgkRcZvNioU+yu8cH4/fDkkuzNUubSsAo7WsqenseAQ5PeoC8XW7YOSPiTOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CjMxEAJKNbjARVHQkm/7oG/AsLILH/SPz0CLYUBb484=;
 b=lqg4EofYbMLvIsQaJrIooS912m5QQcjnm66r1iiT8XDVTaH0PPftBmkrC85Siv5dkBR8foKUG2Bok7+Jz/l895fDRJOdZfMSIthKSbXb7L+0Yk5vO0u4+JUaKt3eqz7ddr86fnXbWJsTupMPisUJk9ZNz+hb3kalE6aIio7WnWY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB2999.namprd10.prod.outlook.com (2603:10b6:a03:85::27)
 by BYAPR10MB3591.namprd10.prod.outlook.com (2603:10b6:a03:124::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 18:55:31 +0000
Received: from BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456]) by BYAPR10MB2999.namprd10.prod.outlook.com
 ([fe80::e180:1ba2:d87:456%4]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 18:55:30 +0000
Date:   Mon, 8 Feb 2021 13:55:26 -0500
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jing Liu <jing2.liu@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
Message-ID: <YCGJHme0fBk+sno3@Konrads-MacBook-Pro.local>
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
 <ae5b0195-b04f-8eef-9e0d-2a46c761d2d5@redhat.com>
 <YCF1d0F0AqPazYqC@google.com>
 <77b27707-721a-5c6a-c00d-e1768da55c64@redhat.com>
 <YCF9GztNd18t1zk/@google.com>
 <c293cdbd-502c-d598-3166-4e177ac21c7a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c293cdbd-502c-d598-3166-4e177ac21c7a@redhat.com>
X-Originating-IP: [138.3.200.11]
X-ClientProxiedBy: SJ0PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:332::10) To BYAPR10MB2999.namprd10.prod.outlook.com
 (2603:10b6:a03:85::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Konrads-MacBook-Pro.local (138.3.200.11) by SJ0PR05CA0065.namprd05.prod.outlook.com (2603:10b6:a03:332::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Mon, 8 Feb 2021 18:55:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 892e7ed1-79fd-4bca-bd6c-08d8cc631b61
X-MS-TrafficTypeDiagnostic: BYAPR10MB3591:
X-Microsoft-Antispam-PRVS: <BYAPR10MB3591B4611CD5736696C04BAD898F9@BYAPR10MB3591.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4BamzlBTJxYbbzcLf3zsg7Qq+PJ3513PmPv1PFXOCG7ItyfeFOqpe3m8V+su2s3lF0sg3c/RIezpMg7vpERQ6gMOSuh4e5/WKPScJPpkJZrhvBrflnmZUZDU27k8VWzGlVz5iCZY9eZPciiSLFHtYJy2xzqyJ7dFEMApInqslFxYuILEhWPB7pCBTx282dZDqvmUPaJHS+nyY6NFmJMiYNjGSh6hCTKgqxcWmV3K+yEb4WHNFbviCyJUg1/zIx8IG34EbIQB74a4V/Vy2q5Wx2egjHwNr6ka5uXt5kMlvCW2nE/EmhvPLRZ/5NTNSC8beWKouqGgVRhjM2ugznkCELLSvUyjV71CyaicnR2R3yKT77JjoXIFWXv58e6R0QstlxV0DhgccITz/HtVYzwy0GgoX73Wk4mNNvugXHfnTGtP2ol6o/6x9No69OnY6EW6tSDzCZvEZUN+H/rxl05AdrA6lGVl+hF4IAJGP13nEQwmmdt6anNyyLsp0qF40ECbYXiqDyooVOTMZguKlu7qKaUY/ZlGTx+RZoOZCKCc4q8jlSOHfOeKZuA0Ca6ehwS/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2999.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(376002)(396003)(16526019)(186003)(8676002)(6506007)(956004)(4326008)(53546011)(8936002)(54906003)(86362001)(316002)(55016002)(2906002)(4001150100001)(83380400001)(26005)(66556008)(66476007)(7696005)(9686003)(478600001)(6666004)(66946007)(5660300002)(52116002)(6916009)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wl7TgjYlNWGr50+5BCbVgWchUdsxmo8Sz3qe8Qw57MWM752dqIsuD+/33gWH?=
 =?us-ascii?Q?HGIm4JRoh+P4kiKBwgg6NeELxBgnbWIkfccUuPP4bvcZTGbIQjF09RpmRzB5?=
 =?us-ascii?Q?zSnyaFQd5PVp2u72zW7ORe5c5+v5TRyxYd1D2MXKD0LgEtFSIwwmptGsEJ0v?=
 =?us-ascii?Q?YEFDJ1JqUJyV/COupkqxd5pnxD4rGxQUV3pB2Mfu7RNMpgqhvk1/o/5SWLUH?=
 =?us-ascii?Q?wpgnk2ZTgGKZ8KEAlhPE/sbf7LPuBvOFl/TMo8qrEIkG3LRt0MmN0Pb+yTGC?=
 =?us-ascii?Q?UmA2ELX7Y8SR9IN/fsLj4/dYWNNBOcMca5edVppr73lGRkAdGSS71Ins97tf?=
 =?us-ascii?Q?Aj85R1UYIHnkpo29w8XEb3vJYql5ylz8bOabCSiRih4tTi5zON+lyAppieaR?=
 =?us-ascii?Q?gpdVkU5wUQRlamY1PeC1vJ5T6AxlbVsRTxO6iBme7453xJbHoreW2ncIDfFQ?=
 =?us-ascii?Q?jJJVCJJ/0MPMhQQFurNxU4u29Cg2Hj3ypuu6t0zMwNM6doMHVIr/4T/RlJIq?=
 =?us-ascii?Q?11DcxgvQL6HXh4VSJ5U84Riz6aNI1GEf4aOmA5rif6msPGM9vNIhHEY2OBGJ?=
 =?us-ascii?Q?OzgMlIgudzCEX2fWELjSkogVqDWksvNDo7Mhzpkdj9M7SIyHOVxMggCmvKZS?=
 =?us-ascii?Q?AXLmUw6IgWQNKG7JggIQndVTXP2JboioJF4IDx6Dd1NSLkZ5pMe52SwTVwnv?=
 =?us-ascii?Q?Ync5zH40eAIviTGXuwjA2X5tQ+S1VqoK7HgFy+dp4V//GcedBQxPZUJQV2ax?=
 =?us-ascii?Q?R9afZf4IXh9+iLuA8VLmgGiQl52dkh59nWBYKIC5qvDrKHMr/OMZ+YstXN8i?=
 =?us-ascii?Q?7jsuSQqu5vr3/+p2jEotp8Qjs5fQagEUKoMZYjhFnfeiLtX8HbPo4RMRa8k1?=
 =?us-ascii?Q?LY/TZDgTDO32nkMvjFwhnRVjY5GX5EeY+J9ag4a2GTrjT0WgCE8semrcQkmJ?=
 =?us-ascii?Q?GkBttc8Zz94HpbMqDb8yNUnO7woGfdpz2TYze1dhnR3t6FyPBO2KmGDyowzp?=
 =?us-ascii?Q?mobIVPrlUds5mTvkRBS/fGGPUntmT0eq7XMBPJ6bOCDxAG9CQB67x7ciNjuG?=
 =?us-ascii?Q?glQUJ8rQefx00tUpG+9XQLQadG59LYEGb5syo/4SL6BqkTCyrSQ//8AK9ml3?=
 =?us-ascii?Q?AvE1Wf+ovk7waB6jEzzjy3D1E+/uFCWfBfAlH1TOaA1Rto1Uae3KoeRwSyZP?=
 =?us-ascii?Q?1UfJVdSpbo4LjrTEj79LJKIbcNaAPKJngAAs5922+oOeOJwOUBnvbKVSy8cy?=
 =?us-ascii?Q?ViYECihQdywwmM4hPod6k5Gg26JpOTBueJ/d6NTfUUO+dfmyGReoxy+0GgS2?=
 =?us-ascii?Q?ScGeRZ2Db9vnLujVADn0R7aO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 892e7ed1-79fd-4bca-bd6c-08d8cc631b61
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2999.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 18:55:30.7103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMQ6XspYVqjRmYiUFXp6qwYHCdKnbYriCRVGjcmi6xd7CGmlQGoWKg10JYBszqBmaDka5CdJ5rFRflKDVwXiFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3591
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080114
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102080114
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 07:12:22PM +0100, Paolo Bonzini wrote:
> On 08/02/21 19:04, Sean Christopherson wrote:
> > > That said, the case where we saw MSR autoload as faster involved EFER, and
> > > we decided that it was due to TLB flushes (commit f6577a5fa15d, "x86, kvm,
> > > vmx: Always use LOAD_IA32_EFER if available", 2014-11-12). Do you know if
> > > RDMSR/WRMSR is always slower than MSR autoload?
> > RDMSR/WRMSR may be marginally slower, but only because the autoload stuff avoids
> > serializing the pipeline after every MSR.
> 
> That's probably adding up quickly...
> 
> > The autoload paths are effectively
> > just wrappers around the WRMSR ucode, plus some extra VM-Enter specific checks,
> > as ucode needs to perform all the normal fault checks on the index and value.
> > On the flip side, if the load lists are dynamically constructed, I suspect the
> > code overhead of walking the lists negates any advantages of the load lists.
> 
> ... but yeah this is not very encouraging.
> 
> Context switch time is a problem for XFD.  In a VM that uses AMX, most
> threads in the guest will have nonzero XFD but the vCPU thread itself will
> have zero XFD.  So as soon as one thread in the VM forces the vCPU thread to
> clear XFD, you pay a price on all vmexits and vmentries.
> 
> However, running the host with _more_ bits set than necessary in XFD should
> not be a problem as long as the host doesn't use the AMX instructions.  So
> perhaps Jing can look into keeping XFD=0 for as little time as possible, and
> XFD=host_XFD|guest_XFD as much as possible.

This sounds like the lazy-fpu (eagerfpu?) that used to be part of the
kernel? I recall that we had a CVE for that - so it may also be worth
double-checking that we don't reintroduce that one.
