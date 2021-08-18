Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD963F0815
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 17:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239480AbhHRPc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 11:32:57 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57972 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230360AbhHRPc5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Aug 2021 11:32:57 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IF6GXG196546;
        Wed, 18 Aug 2021 11:32:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eCRrdaGsRdvPUi7IeqepGp/ywWUw5F51O1+63GkhWAA=;
 b=PuR6Mlm5pM8GyjDoNKEpU/3zFdhmGj8y4VoFadXSVsvwOTWi2M2vE5IakO2Cp4TM/4DJ
 42qIAXFqnvob8Bc3SiHB3Wjn7zN+Qvgu+FGifZdHJmpICdvKcRsdhK9RLNzS5Ccm9lbN
 cqanSFR8Tns13yWd/WLRTT/41QZLwqLTvX4W3foBwsTqaAnS34348uR/Sj0XWJsTpYS1
 WHg3IFym5Gpp/DcCY3ySqtXFhl0ZI9NqYxiBN+u/8kL8uqVpfAm0mU8sETwx4PL+rUaW
 gm+jJ9NSMynq1yWRw8F30H7pO2VMu4QqWI0I+o67cyvqaWD6OGIKgib914SGty1PErK/ aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcdxstt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 11:32:17 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17IF6Q4A001075;
        Wed, 18 Aug 2021 11:32:16 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3agcdxstse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 11:32:16 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17IFCN1J018306;
        Wed, 18 Aug 2021 15:32:15 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02wdc.us.ibm.com with ESMTP id 3ae5fdu45e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 15:32:15 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17IFWEFe40436158
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 15:32:14 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D2B411207E;
        Wed, 18 Aug 2021 15:32:14 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86BE511206E;
        Wed, 18 Aug 2021 15:32:13 +0000 (GMT)
Received: from Tobins-MacBook-Pro-2.local (unknown [9.77.128.89])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 18 Aug 2021 15:32:13 +0000 (GMT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Steve Rutherford <srutherford@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, tobin@ibm.com, jejb@linux.ibm.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        dgilbert@redhat.com, frankeh@us.ibm.com,
        dovmurik@linux.vnet.ibm.com
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
 <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
 <37796fd1-bbc2-f22c-b786-eb44f4d473b9@linux.ibm.com>
 <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
From:   Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Message-ID: <458ba932-5150-8706-3958-caa4cc67c8e3@linux.ibm.com>
Date:   Wed, 18 Aug 2021 11:32:12 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CABayD+evf56U4yT2V1TmEzaJjvV8gutUG5t8Ob2ifamruw5Qrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HMlJOmVklu8maihlgMmo1RpAyLTE7Xx1
X-Proofpoint-GUID: 01YqbAMFYi8XhmRsCgn69YUyl21qpsBE
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-18_05:2021-08-17,2021-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108180095
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/17/21 6:04 PM, Steve Rutherford wrote:
> On Tue, Aug 17, 2021 at 1:50 PM Tobin Feldman-Fitzthum
> <tobin@linux.ibm.com> wrote:
>> This is essentially what we do in our prototype, although we have an
>> even simpler approach. We have a 1:1 mapping that maps an address to
>> itself with the cbit set. During Migration QEMU asks the migration
>> handler to import/export encrypted pages and provides the GPA for said
>> page. Since the migration handler only exports/imports encrypted pages,
>> we can have the cbit set for every page in our mapping. We can still use
>> OVMF functions with these mappings because they are on encrypted pages.
>> The MH does need to use a few shared pages (to communicate with QEMU,
>> for instance), so we have another mapping without the cbit that is at a
>> large offset.
>>
>> I think this is basically equivalent to what you suggest. As you point
>> out above, this approach does require that any page that will be
>> exported/imported by the MH is mapped in the guest. Is this a bad
>> assumption? The VMSA for SEV-ES is one example of a region that is
>> encrypted but not mapped in the guest (the PSP handles it directly). We
>> have been planning to map the VMSA into the guest to support migration
>> with SEV-ES (along with other changes).
> Ahh, It sounds like you are looking into sidestepping the existing
> AMD-SP flows for migration. I assume the idea is to spin up a VM on
> the target side, and have the two VMs attest to each other. How do the
> two sides know if the other is legitimate? I take it that the source
> is directing the LAUNCH flows?

Yeah we don't use PSP migration flows at all. We don't need to send the 
MH code from the source to the target because the MH lives in firmware, 
which is common between the two. We start the target like a normal VM 
rather than waiting for an incoming migration. The plan is to treat the 
target like a normal VM for attestation as well. The guest owner will 
attest the target VM just like they would any other VM that is started 
on their behalf. Secret injection can be used to establish a shared key 
for the source and target.

-Tobin

>
> --Steve
>
