Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C95A3F6B81
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 00:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbhHXWB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 18:01:58 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2880 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235507AbhHXWB5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Aug 2021 18:01:57 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17OLZcHT128489;
        Tue, 24 Aug 2021 18:00:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : subject : to : cc
 : message-id : date : mime-version : content-type :
 content-transfer-encoding; s=pp1;
 bh=II37AGyoTqYl1RM2pq4+IkYzWq0/yoTZqOEp89zr4gs=;
 b=fyVSq3x/CH9u3ZqpHm+MvckuoLmVQDd3Wkb8HRE4RfBQ8VKRF8dNJOFmz6QcoXrpkHc4
 CH0hZzqL5NXzDJB3kjtIDXW145UweVeNFiKjPLJ5pCtYLNPdIthIVeVUfDeugcvLf1hH
 OQTebVE7CdhwM2v4P7+osuNSOombUHd02InYZ8eWHC1A206869IhDPsqZvxRIQn7tvXH
 uL0lxY9HxAgF4qpFZCJWI4yukTKGZRqa0/fUdL0CN3WstKkTnhIxWOkynFDKsZhcb1tl
 +65HHwXy3q4oSfd0Zf9fJKo1GA32aH0AOykjU8qaH0sToZZPoujz3qrWlnRQxvZT2OSL ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3an3wn13et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 18:00:55 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17OLZfET128711;
        Tue, 24 Aug 2021 18:00:55 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3an3wn13e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 18:00:55 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17OLxWiW010171;
        Tue, 24 Aug 2021 22:00:53 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 3ajs4ck1w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Aug 2021 22:00:53 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17OM0q9U25887014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 22:00:52 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A082E2805A;
        Tue, 24 Aug 2021 22:00:52 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D5B828068;
        Tue, 24 Aug 2021 22:00:52 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.65.80.64])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 Aug 2021 22:00:52 +0000 (GMT)
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Subject: Re: Fw: [EXTERNAL] Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Habkost, Eduardo" <ehabkost@redhat.com>,
        "S. Tsirkin, Michael" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        James Bottomley <jejb@linux.ibm.com>,
        Dov Murik <dovmurik@linux.vnet.ibm.com>,
        Hubertus Franke <frankeh@us.ibm.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Ashish Kalra <ashish.kalra@amd.com>
Message-ID: <6213e737-66ec-f8f0-925b-eeb847b7b790@linux.ibm.com>
Date:   Tue, 24 Aug 2021 18:00:51 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: weIC-8CrKeGkeJtRqB0EKUGbtFxsBjC-
X-Proofpoint-ORIG-GUID: jc8ZCyAUh1KLGF-Qy60Ii-tB29ayTfVO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-24_06:2021-08-24,2021-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 adultscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 phishscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 04:15:46PM +0200, Paolo Bonzini wrote:

> Hi,
>
> first of all, thanks for posting this work and starting the discussion.
>
> However, I am not sure if the in-guest migration helper vCPUs should use
> the existing KVM support code.  For example, they probably can just
> always work with host CPUID (copied directly from
> KVM_GET_SUPPORTED_CPUID), and they do not need to interface with QEMU's
> MMIO logic.  They would just sit on a "HLT" instruction and communicate
> with the main migration loop using some kind of standardized ring buffer
> protocol; the migration loop then executes KVM_RUN in order to start the
> processing of pages, and expects a KVM_EXIT_HLT when the VM has nothing
> to do or requires processing on the host.
> The migration helper can then also use its own address space, for
> example operating directly on ram_addr_t values with the helper running
> at very high virtual addresses.  Migration code can use a
> RAMBlockNotifier to invoke KVM_SET_USER_MEMORY_REGION on the mirror VM
> (and never enable dirty memory logging on the mirror VM, too, which has
> better performance).
>
> With this implementation, the number of mirror vCPUs does not even have
> to be indicated on the command line.  The VM and its vCPUs can simply be
> created when migration starts.  In the SEV-ES case, the guest can even
> provide the VMSA that starts the migration helper.

It might make sense to tweak the mirror support code so that it is more
closely tied to migration and the migration handler. On the other hand,
the usage of a mirror VM might be more general than just migration. In
some ways the mirror offers similar functionality to the VMPL in SNP,
providing a way to run non-workload code inside the enclave. This
potentially has uses beyond migration. If this is the case, do maybe we
want to keep the mirror more general.

It's also worth noting that the SMP interface that Ashish is using to
specify the mirror might come in handy if we ever want to have more than
one vCPU in the mirror. For instance we might want to use multiple MH
vCPUs to increase throughput.

-Tobin

> The disadvantage is that, as you point out, in the future some of the
> infrastructure you introduce might be useful for VMPL0 operation on
> SEV-SNP.  My proposal above might require some code duplication.
> However, it might even be that VMPL0 operation works best with a model
> more similar to my sketch of the migration helper; it's really too early
> to say.
>
> Paolo
