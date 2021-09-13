Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D3B408D29
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 15:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241219AbhIMNXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 09:23:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:21308 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240435AbhIMNV4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 09:21:56 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DD5scd015554;
        Mon, 13 Sep 2021 13:19:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IMOSH4tm0knY1eywg+CumHDM+BIKSpl3RI+CmUhPSG8=;
 b=xzleg+kJ99HLLZ+fQYUE4bURpHGaE1MCgZrIEUufQ4OY8OQyV539LSZg0F1xL+nOdOOg
 CibdTUG2UECwZ1bLuK2Doe3bLF8faCGSsav4nmyNZMyQsQe3JqdBi+p8qeFbIT2CwM70
 XdZlQ4S2/NYhQmv5IiUz2SbsZt2u7DYwP96xatRzxQc6/fSl/F6thzf5/tvlWQWE8Ocu
 eIPzA8lHQ5BWgkoJsdIvuQ4c42N0v8oSbsyJ9Sp1oMT7HaoOdu57hvaFlvLJH+XNLIpe
 Y8vb7RpBVe+Gu8kA5Wn1T3SXQnmkFEFTwmg10CbFRsdbFsxBt66IxWPMioKrNWw+epnw zQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : references : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2020-01-29;
 bh=IMOSH4tm0knY1eywg+CumHDM+BIKSpl3RI+CmUhPSG8=;
 b=sMqg9Xq8n5of1I+AK2HiWc66AyxF9VG9kS2CnhUa/4nSHUk0+YxYoiMHGBAKZCjBXcNC
 xcaMlGrCwk3w2nAVphqTCi8jDCT0GJpDACrYvsD25Y7NM7DL1L4Tao/B1KG/Du5RHY7s
 h5eh/5XfDAlgYvp6ydmLRKnSE1G54RmVYBp4Ndd+gydHg8CnjpJh4/Dbur7uL+kSjfN5
 txnjx5o5T/S9hxpum+9b5gbt7LEr6tNi0OsfVwpKdsf3g2R7QRSu1WvWAg94bNKpXHUq
 SknEzF77pkMkIfVxovoC50irxszvfCGJA69HXme+oxQPKHBbS9ufN03Vm2yZlj9gzNJd fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k1sajbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 13:19:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18DDGSLE065777;
        Mon, 13 Sep 2021 13:19:37 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by aserp3030.oracle.com with ESMTP id 3b0jgbgta9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Sep 2021 13:19:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZxcEIkyTrsszjWMQeYPXujYt80n3OmGnVJ8wuVLa7jlY7yrKLdEWO5AqupaJf8+Kaf+MeqeKFcltODM5DLpuZp9BAwmWcP6lSFHgDR8x+X9O+ncgbT0+/Iprny4qOdFy4kNIkFSWREhchWVhhjbD6RRoKiS1Yum+DTbZEQ/ksjGfADKAveBGwnbCPT7Bu9YSUiJcDaRxKNMu4WBlf3Cs0WSc3FSRzbhF/Yi5uJBz2yrodBWvm13SbWjoV93O5onDA0EU3WMxSguyp4c9l650ySA6hcbLXbEnJ2N9OR1ADHjcKskVFV0nb1o9JGhYmsyJTDsW8+HRQ8tpX35eW81Bog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=IMOSH4tm0knY1eywg+CumHDM+BIKSpl3RI+CmUhPSG8=;
 b=EcrYV+uMM7m/XDC+pW/j5NiEb0cEoHmmCeQLKVhSYHUOf9oK0MpZDwtuQ106UlaJe3LVlDQuUr0HxXcWpeLod0OwJYNswglRryGq2l2ardTO6BwYCsy1h4RqT1sDA2JqlF87EIDBIzbnOp/Om257Y7oLuRChrIW9AzVNUHx7Y3aXfmDhqYwfC7cBgk0IFZfPBjt6kSIDSGgWeYJXKtvQMVXtgeD0v6xx6Q83EuTxxfGLzgVyqoPwoj1BKWGgWL/dE44MAsnOJX0w3pCC8aEoZCAqs0AK7sYNNTA6ui49ZTsklPEK3AUxM/NzId9A6G2AzfNS6yTqXhtVHHI45vBmew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IMOSH4tm0knY1eywg+CumHDM+BIKSpl3RI+CmUhPSG8=;
 b=rUbpcfRJ++Adx6z9jMOQZjZrJTMDLMvBhsX1GY+QQT/FljnYkeYZdCvW5dRPtjlhiFr+KCEQ5g+8LcXRnAE9rYeAkXzbmEqj3L5eWWqTjL1j6zJ1TBpRknTBdlPJ8qWFX1cK2gIb9DKgTjSVj0QQ/wxmCpIMOkcXh4LHCuFTYMc=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3148.namprd10.prod.outlook.com (2603:10b6:5:1a4::21)
 by DM6PR10MB3386.namprd10.prod.outlook.com (2603:10b6:5:1a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Mon, 13 Sep
 2021 13:19:35 +0000
Received: from DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::7c73:f280:20d6:35cf]) by DM6PR10MB3148.namprd10.prod.outlook.com
 ([fe80::7c73:f280:20d6:35cf%3]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 13:19:35 +0000
From:   David Edmondson <david.edmondson@oracle.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>, x86@kernel.org,
        kvm@vger.kernel.org, Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH v4 3/4] KVM: x86: On emulation failure, convey the exit
 reason, etc. to userspace
References: <20210813071211.1635310-1-david.edmondson@oracle.com>
        <20210813071211.1635310-4-david.edmondson@oracle.com>
        <YTEaZVjZwhOD0gMi@google.com>
Date:   Mon, 13 Sep 2021 14:19:28 +0100
In-Reply-To: <YTEaZVjZwhOD0gMi@google.com> (Sean Christopherson's message of
        "Thu, 2 Sep 2021 18:39:33 +0000")
Message-ID: <cun4kaoehpb.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0252.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::24) To DM6PR10MB3148.namprd10.prod.outlook.com
 (2603:10b6:5:1a4::21)
MIME-Version: 1.0
Received: from disaster-area (2001:8b0:bb71:7140:64::1) by LO2P265CA0252.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:8a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 13:19:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5abee6ec-9af4-4de2-6e87-08d976b9214a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3386:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB3386137A7641958464E44B4188D99@DM6PR10MB3386.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rw4Ef5LMbGF/HJhtjKDP4gb8JKm7V2kWQ6JdaYAy62VPUpYt5maI63VFksxwEoJBpezuYuHt3rsjGcZfdpoh65wWJ+vAfx/HagmHpG23a5H1kKvousb+P3mYxFG3lDewfUMQewHm+0ClbsLPwFkCWIrAfYGFrdoJjtKdmAL0E6M7qxwCPj9pmUCJdKR0Yb69BPS55prRptxfvXPbBYVmVQRQuAHWxsLypbU/PgrAU4WzfGUMCLy9FtAzRADinRTfkF0I4xzkJo70dEQnAcV1DFZxIHcdiHiMxMfqSqeSaYYzZK7viO04piG6l9LntvDkUFTGID8tpEgSO0383YsvGP+Cqh+HPONp52TdWspXRQLXe8fcfOMIPP9JzvxlR/yIMXbwHjJ5r8cj+12dbDaMZIrCuMLf+DEAQONhLT1D/rXCYjegfYITqYOgt7LOU3dQHweYpgPjibYUJOc3Z4fHd3Fw32JFOzxWReAEU0lya4aAUusCIk4EiIKJUB5ZcFbWSr4C0qg9O5z2yccj6IVsj9a7cZKS0AFALZZFDerb9SUZlz5vVekf+PuplH7vKsXUCvW5vgkAvWHJhu9KSCxbniqKe8Us1FOB/2ugVdwvnYIaobYolFI+lRmjtoUAEIvg37nhpqFeYpGA8mv0Vt2hew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3148.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(396003)(366004)(346002)(6666004)(186003)(316002)(66476007)(8676002)(44832011)(52116002)(6496006)(66946007)(4326008)(66556008)(2906002)(107886003)(54906003)(478600001)(2616005)(36756003)(5660300002)(6486002)(6916009)(8936002)(86362001)(38100700002)(83380400001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xX4gmtij87eKetv/NAzvlg4LosmUeJkPFJJ3tc6qHIfpIID1ogleroo8Fey1?=
 =?us-ascii?Q?UJo25FsOKmLBY7D0YqV/ThWq13DH+abCVN2e/9jfXrFextmshAVQSurDYqjP?=
 =?us-ascii?Q?fslLdzdRb1oWF4uMQtiliUzhquP5UaIlgp7zJqpcjufC0RX7cdcYaeIpRqko?=
 =?us-ascii?Q?T4mGAx4vS2M7UUPObsC4rR7Q1NgBWoD6A6T7RXbkvMtl5O2y5dD125tbe8sM?=
 =?us-ascii?Q?5cz97wLC1+05knGWNEAq2Tdahx2loCu0S5tMYKL+Z/luA2a38UmszfvWQdpA?=
 =?us-ascii?Q?479QGZLKgX8NJVvKh9L9TVZHTdr5x4fo4Ou0d9xvl/kP2Ai9pxaUkZAyg1xt?=
 =?us-ascii?Q?O8JHx088qKZ5Wr4//yYQvEGn8KfWgpuevX8Ilw87fJ71RhGnqGtkzXHgJDkF?=
 =?us-ascii?Q?eZ0Ci6wr6cdIQigGrTS9rQAP5RHaBlujkClBd7LxBaxHXvXM2OeTwvAyjLWF?=
 =?us-ascii?Q?WdLnBN9vup9DxKjL+VGL9CgsYuUNBrtq+0CETjwfB1xBvGJ4n5YYIw1Fncqz?=
 =?us-ascii?Q?i3PC1dBA7Gqq/awe30P/TBoqHcw8in2EWprWaF/xbYPlaiD1S5LC93qmQBxB?=
 =?us-ascii?Q?PkcM2wvCg0grzZ4KW9YVuIyGMfI/DLNkUTZV7v/mKic72AZi7SIjiJnaaXNv?=
 =?us-ascii?Q?uXB9ERTeVyPuBUD+MVvrp3VwLRN0QlNFs6gh1stLMib6TVERaFg25hvLFIcs?=
 =?us-ascii?Q?SA/XXZ/9/wjvyehqSZessR+9pPoSU50oZ0hRpokUYwlwvPOb/Ep5fTA4Qk69?=
 =?us-ascii?Q?iwygwgleFgmuUba59qe8NnbB3B+ZKuEm8OsCIhrn7ad3Gp3IfEHtafCmAHEf?=
 =?us-ascii?Q?apyMN0NquCuT7McHwawaodmGFfAcR/8oPiDl89CgAo9s6/8b+W468jDQd7on?=
 =?us-ascii?Q?PRYfn+uVHjFQAGa9kVo36LBTHbGhsEbhf+zUcK9oCPyILooeWwS601Unq2iI?=
 =?us-ascii?Q?LHkKFQnTxcPvaPjomAQrAv/iff/amy3BfmiPfHOjWJ2M8R9uvZtJ3RpLp0lj?=
 =?us-ascii?Q?QaZRLrUu5ACQROPXsMfrOT9s5y4wMa3GOsmuqn3QKTTTrnGQi9aY4dsAXe1x?=
 =?us-ascii?Q?S3syc6FvndwXUW682lZxWCyGe5Z3Ct4imj7Rzr9E/p1r8UeHPGeDDxexeg18?=
 =?us-ascii?Q?RxBGm9ctO+3jA6GIVwUoHMu5hONMMQEBiQlyT+mcPOxykg18LpG4+Bj8vNDz?=
 =?us-ascii?Q?DEhbZaTO5kRU4Vc3tGS4RE3DHOSDGUUhk0/3PbyJ67JESbsQS+hW2IV4oyjU?=
 =?us-ascii?Q?Os/Ln0ib1W4eDOk04io+n4jNolTx4LUNaL6FcVZy0ThPK7B40e03KLuRdUhx?=
 =?us-ascii?Q?6enGOn5L7pH/DJZxbt3HgKEH378ujR0t788uuJNIHGJauw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5abee6ec-9af4-4de2-6e87-08d976b9214a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3148.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 13:19:35.1747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EpcD4eYHHLdZ2X8m6Frv9weWMpUutEEivGMS5LMvuC43vGj6ZmGS5Hemvqub8JI6uCVIkJfw/8XAZRf8Bf5OKs4Q4uclJrMkQBcyF6rjPuI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3386
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10105 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130089
X-Proofpoint-ORIG-GUID: uqg3cSOQUfU0unzzsoFtMnIieU7zCQ3h
X-Proofpoint-GUID: uqg3cSOQUfU0unzzsoFtMnIieU7zCQ3h
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Fri, Aug 13, 2021, David Edmondson wrote:
>> -static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>> +static void prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
>> +					   u8 ndata, u8 *insn_bytes, u8 insn_size)
>>  {
>> -	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>> -	u32 insn_size = ctxt->fetch.end - ctxt->fetch.data;
>>  	struct kvm_run *run = vcpu->run;
>> +	u8 ndata_start;
>> +	u64 info[5];
>> +
>> +	/*
>> +	 * Zero the whole array used to retrieve the exit info, casting to u32
>> +	 * for select entries will leave some chunks uninitialized.
>> +	 */
>> +	memset(&info, 0, sizeof(info));
>> +
>> +	static_call(kvm_x86_get_exit_info)(vcpu, (u32 *)&info[0], &info[1],
>> +					   &info[2], (u32 *)&info[3],
>> +					   (u32 *)&info[4]);
>>  
>>  	run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>>  	run->emulation_failure.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> -	run->emulation_failure.ndata = 0;
>> +
>> +	/*
>> +	 * There's currently space for 13 entries, but 5 are used for the exit
>> +	 * reason and info.  Restrict to 4 to reduce the maintenance burden
>> +	 * when expanding kvm_run.emulation_failure in the future.
>> +	 */
>> +	if (WARN_ON_ONCE(ndata > 4))
>> +		ndata = 4;
>> +
>> +	/* Always include the flags as a 'data' entry. */
>> +	ndata_start = 1;
>>  	run->emulation_failure.flags = 0;
>>  
>>  	if (insn_size) {
>> -		run->emulation_failure.ndata = 3;
>> +		ndata_start += (sizeof(run->emulation_failure.insn_size) +
>> +				sizeof(run->emulation_failure.insn_bytes)) /
>> +			sizeof(u64);
>
> Hrm, I like the intent, but the end result ends up being rather convoluted and
> unnecessarily scary, e.g. this would do the wrong thing if the combined size of
> the fields is not a multiple of 8.  That's obviously is not true, but relying on
> insn_size/insn_bytes being carefully selected while simultaneously obscuring that
> dependency is a bit mean.  What about a compile-time assertion with a more reader
> friendly literal for bumping the count?
>
> 		BUILD_BUG_ON((sizeof(run->emulation_failure.insn_size) +
> 			      sizeof(run->emulation_failure.insn_bytes) != 16));
> 		ndata_start += 2;

Okay.

>>  		run->emulation_failure.flags |=
>>  			KVM_INTERNAL_ERROR_EMULATION_FLAG_INSTRUCTION_BYTES;
>>  		run->emulation_failure.insn_size = insn_size;
>>  		memset(run->emulation_failure.insn_bytes, 0x90,
>>  		       sizeof(run->emulation_failure.insn_bytes));
>> -		memcpy(run->emulation_failure.insn_bytes,
>> -		       ctxt->fetch.data, insn_size);
>> +		memcpy(run->emulation_failure.insn_bytes, insn_bytes, insn_size);
>>  	}
>> +
>> +	memcpy(&run->internal.data[ndata_start], info, sizeof(info));
>
> Oof, coming back to this code after some time away, "ndata_start" is confusing.
> I believe past me thought that it would help convey that "info" is lumped into
> the arbitrary data, but for me at least it just ends up making the interaction
> with @data and @ndata more confusing.  Sorry for the bad suggestion :-/
>
> What about info_start?  IMO, that makes the memcpy more readable.  Another option
> would be to have the name describe the number of "ABI enries", but I can't come
> up with a variable name that's remotely readable.
>
> 	memcpy(&run->internal.data[info_start], info, sizeof(info));
> 	memcpy(&run->internal.data[info_start + ARRAY_SIZE(info)], data,
> 	       ndata * sizeof(data[0]));

Okay.

>> +	memcpy(&run->internal.data[ndata_start + ARRAY_SIZE(info)], data,
>> +	       ndata * sizeof(u64));
>
> Not that it really matters, but it's probably better to use sizeof(data[0]) or
> sizeof(*data).  E.g. if we do screw up the param in the future, we only botch the
> output formatting, as opposed to dumping kernel stack data to userspace.

Agreed.

>> +
>> +	run->emulation_failure.ndata = ndata_start + ARRAY_SIZE(info) + ndata;
>>  }
>>  
>> +static void prepare_emulation_ctxt_failure_exit(struct kvm_vcpu *vcpu)
>> +{
>> +	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
>> +
>> +	prepare_emulation_failure_exit(vcpu, NULL, 0, ctxt->fetch.data,
>> +				       ctxt->fetch.end - ctxt->fetch.data);
>> +}
>> +
>> +void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu, u64 *data,
>> +					  u8 ndata)
>> +{
>> +	prepare_emulation_failure_exit(vcpu, data, ndata, NULL, 0);
>> +}
>> +EXPORT_SYMBOL_GPL(__kvm_prepare_emulation_failure_exit);
>> +
>> +void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu)
>> +{
>> +	__kvm_prepare_emulation_failure_exit(vcpu, NULL, 0);
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_prepare_emulation_failure_exit);
>> +
>>  static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>>  {
>>  	struct kvm *kvm = vcpu->kvm;
>> @@ -7502,16 +7551,14 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
>>  
>>  	if (kvm->arch.exit_on_emulation_error ||
>>  	    (emulation_type & EMULTYPE_SKIP)) {
>> -		prepare_emulation_failure_exit(vcpu);
>> +		prepare_emulation_ctxt_failure_exit(vcpu);
>>  		return 0;
>>  	}
>>  
>>  	kvm_queue_exception(vcpu, UD_VECTOR);
>>  
>>  	if (!is_guest_mode(vcpu) && static_call(kvm_x86_get_cpl)(vcpu) == 0) {
>> -		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> -		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> -		vcpu->run->internal.ndata = 0;
>> +		prepare_emulation_ctxt_failure_exit(vcpu);
>>  		return 0;
>>  	}
>>  
>> @@ -12104,9 +12151,7 @@ int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>>  	 * doesn't seem to be a real use-case behind such requests, just return
>>  	 * KVM_EXIT_INTERNAL_ERROR for now.
>>  	 */
>> -	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> -	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> -	vcpu->run->internal.ndata = 0;
>> +	kvm_prepare_emulation_failure_exit(vcpu);
>>  
>>  	return 0;
>>  }
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 6c79c1ce3703..e86cc2de7b5c 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -397,6 +397,12 @@ struct kvm_run {
>>  		 * "ndata" is correct, that new fields are enumerated in "flags",
>>  		 * and that each flag enumerates fields that are 64-bit aligned
>>  		 * and sized (so that ndata+internal.data[] is valid/accurate).
>> +		 *
>> +		 * Space beyond the defined fields may be used to
>
> Please run these out to 80 chars.  Even 80 is a soft limit, it's ok to run over
> a bit if the end result is (subjectively) prettier. 
>
>> +		 * store arbitrary debug information relating to the
>> +		 * emulation failure. It is accounted for in "ndata"
>> +		 * but otherwise unspecified and is not represented in
>
> Explicitly state the format is unspecified?
>
>> +		 * "flags".
>
> And also explicitly stating the debug info isn't ABI, e.g.
>
> 		 * Space beyond the defined fields may be used to store arbitrary
> 		 * debug information relating to the emulation failure. It is
> 		 * accounted for in "ndata" but the format is unspecified and
> 		 * is not represented in "flags".  Any such info is _not_ ABI!

Okay.

>>  		 */
>>  		struct {
>>  			__u32 suberror;
>> @@ -408,6 +414,7 @@ struct kvm_run {
>>  					__u8  insn_bytes[15];
>>  				};
>>  			};
>> +			/* Arbitrary debug data may follow. */
>>  		} emulation_failure;
>>  		/* KVM_EXIT_OSI */
>>  		struct {
>> -- 
>> 2.30.2
>> 
