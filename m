Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7787B48E77
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 21:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFQTZ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 15:25:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49768 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726514AbfFQTZ6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jun 2019 15:25:58 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJJ1ZQ042979
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 15:25:56 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t6fjuk4e7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 15:25:56 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farosas@linux.ibm.com>;
        Mon, 17 Jun 2019 20:25:55 +0100
Received: from b01cxnp22033.gho.pok.ibm.com (9.57.198.23)
        by e11.ny.us.ibm.com (146.89.104.198) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Jun 2019 20:25:53 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5HJPqdC37945746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 19:25:52 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F52111206B;
        Mon, 17 Jun 2019 19:25:52 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D7E3112063;
        Mon, 17 Jun 2019 19:25:51 +0000 (GMT)
Received: from localhost (unknown [9.85.180.35])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTPS;
        Mon, 17 Jun 2019 19:25:50 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, benh@kernel.crashing.org, mpe@ellerman.id.au,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        david@gibson.dropbear.id.au, aik@ozlabs.ru
Subject: Re: [PATCH v2] KVM: PPC: Report single stepping capability
In-Reply-To: <20190617061608.y5qw26i53si76qqt@oak.ozlabs.ibm.com>
References: <20190529222219.27994-1-farosas@linux.ibm.com> <20190617061608.y5qw26i53si76qqt@oak.ozlabs.ibm.com>
Date:   Mon, 17 Jun 2019 16:25:49 -0300
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
x-cbid: 19061719-2213-0000-0000-000003A02F4C
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011280; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01219392; UDB=6.00641389; IPR=6.01000533;
 MB=3.00027347; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-17 19:25:55
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061719-2214-0000-0000-00005EE48227
Message-Id: <87y3202ev6.fsf@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=762 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paul Mackerras <paulus@ozlabs.org> writes:

> On Wed, May 29, 2019 at 07:22:19PM -0300, Fabiano Rosas wrote:
>> When calling the KVM_SET_GUEST_DEBUG ioctl, userspace might request
>> the next instruction to be single stepped via the
>> KVM_GUESTDBG_SINGLESTEP control bit of the kvm_guest_debug structure.
>> 
>> We currently don't have support for guest single stepping implemented
>> in Book3S HV.
>> 
>> This patch adds the KVM_CAP_PPC_GUEST_DEBUG_SSTEP capability in order
>> to inform userspace about the state of single stepping support.
>
> Comment/question below:
>
>> --- a/arch/powerpc/kvm/powerpc.c
>> +++ b/arch/powerpc/kvm/powerpc.c
>> @@ -538,6 +538,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_IMMEDIATE_EXIT:
>>  		r = 1;
>>  		break;
>> +	case KVM_CAP_PPC_GUEST_DEBUG_SSTEP:
>> +#ifdef CONFIG_BOOKE
>> +		r = 1;
>> +		break;
>> +#endif
>
> In the !CONFIG_BOOKE case, this will fall through to code which will
> return 0 for HV KVM or 1 for PR KVM.  Is that what was intended?

Yes. The intention is to return 0 for HV and 1 for everything else.

> If so, then why do we need the CONFIG_BOOKE case?  Isn't hv_enabled
> always 0 on Book E?

Good point. I made a mistake there indeed.

> In any case, I think this needs at least a /* fall through */ comment
> in the code, and something explicit in the patch description to say
> that we intend to return 1 on PR KVM.

I'll send another version.

Thanks

