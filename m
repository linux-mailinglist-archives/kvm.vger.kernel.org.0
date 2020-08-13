Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8B6243A8C
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 15:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgHMNJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 09:09:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgHMNJ5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 09:09:57 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DD1kd2073638;
        Thu, 13 Aug 2020 09:09:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=6+ve0ImyEBms6UI2GeZrvxzhr2Re83rk7CeeuodOzvo=;
 b=A2HmcKXxzkd2X95ZhcAhyoZ1SalLCKrfp1or22n/4e9jULK6uPweLqXSlYESBpkG0juP
 +3xCvF7+W6VNhkqw01tjlBzl9Xt/8oEZ/xQdE3fQdAhCNzH3lTeD4wIaQIgFgbbuEy4k
 iJq1bR1tfvN0EsFj1Mn9lbDfWSdYylDcoPh6l1x9W+HlXpSnDYpCmX7VviFBMCqzFYtf
 fVkMRe9Ilam/XnwIw9AI8fcqkyv2hHjklcGHx8WAkIlA/xn3kKiQ6H0hPVgXgKT1W3+8
 KhRjI6J7i8aUlAwlKfQHY9UyVrAQw6zEhj4uFhHCYjqykwyMR+jv0UlW3pFOltHpC1Cq AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w0n0jych-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:09:51 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DD2Zut078364;
        Thu, 13 Aug 2020 09:09:50 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w0n0jyc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 09:09:50 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DD525w026961;
        Thu, 13 Aug 2020 13:09:49 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 32skp9mjvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 13:09:49 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DD9mvN48955718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 13:09:48 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A30EE28058;
        Thu, 13 Aug 2020 13:09:48 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0A5028059;
        Thu, 13 Aug 2020 13:09:46 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.7.238])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 13:09:46 +0000 (GMT)
Subject: Re: [PATCH v2] PCI: Introduce flag for detached virtual functions
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     bhelgaas@google.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        mpe@ellerman.id.au, oohall@gmail.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <1597260071-2219-1-git-send-email-mjrosato@linux.ibm.com>
 <1597260071-2219-2-git-send-email-mjrosato@linux.ibm.com>
 <20200812143254.2f080c38@x1.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <d2237715-298c-30a9-a05d-2b1c72476441@linux.ibm.com>
Date:   Thu, 13 Aug 2020 09:09:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200812143254.2f080c38@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_10:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 impostorscore=0
 adultscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130094
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/12/20 4:32 PM, Alex Williamson wrote:
> On Wed, 12 Aug 2020 15:21:11 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> s390x has the notion of providing VFs to the kernel in a manner
>> where the associated PF is inaccessible other than via firmware.
>> These are not treated as typical VFs and access to them is emulated
>> by underlying firmware which can still access the PF.  After
>> abafbc55 however these detached VFs were no longer able to work
>> with vfio-pci as the firmware does not provide emulation of the
>> PCI_COMMAND_MEMORY bit.  In this case, let's explicitly recognize
>> these detached VFs so that vfio-pci can allow memory access to
>> them again.
>>
> 
> Might as well include a fixes tag too.
> 
> Fixes: abafbc551fdd ("vfio-pci: Invalidate mmaps and block MMIO access on disabled memory")
> 
> You might also extend the sha1 in the log to 12 chars as well, or
> replace it with a reference to the fixes tag.
> 
Sure.

>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
..snip..
>> diff --git a/include/linux/pci.h b/include/linux/pci.h
>> index 8355306..23a6972 100644
>> --- a/include/linux/pci.h
>> +++ b/include/linux/pci.h
>> @@ -445,6 +445,7 @@ struct pci_dev {
>>   	unsigned int	is_probed:1;		/* Device probing in progress */
>>   	unsigned int	link_active_reporting:1;/* Device capable of reporting link active */
>>   	unsigned int	no_vf_scan:1;		/* Don't scan for VFs after IOV enablement */
>> +	unsigned int	detached_vf:1;		/* VF without local PF access */
> 
> Is there too much implicit knowledge in defining a "detached VF"?  For
> example, why do we know that we can skip the portion of
> vfio_config_init() that copies the vendor and device IDs from the
> struct pci_dev into the virtual config space?  It's true on s390x, but
> I think that's because we know that firmware emulates those registers
> for us.  We also skip the INTx pin register sanity checking.  Do we do
> that because we haven't installed the broken device into an s390x
> system?  Because we know firmware manages that for us too?  Or simply
> because s390x doesn't support INTx anyway, and therefore it's another
> architecture implicit decision?

That's a fair point.  This was also discussed (overnight for me) in 
another thread that this patch is very s390-specific.  It doesn't have 
to be, we could also emulate these additional pieces to make things more 
general-purpose here.

> 
> If detached_vf is really equivalent to is_virtfn for all cases that
> don't care about referencing physfn on the pci_dev, then we should
> probably have a macro to that effect.  Otherwise, if we're just trying
> to describe that the memory bit of the command register is
> unimplemented but always enabled, like a VF, should we specifically
> describe that attribute instead?  If so, should we instead do that with
> pci_dev_flags_t?  Thanks,

Well, that's the particular issue that got us looking at this but I'm 
not so sure we wouldn't find further oddities later, hence the desire 
for a more general-purpose bit.

> 
> Alex
> 
>>   	pci_dev_flags_t dev_flags;
>>   	atomic_t	enable_cnt;	/* pci_enable_device has been called */
>>   
> 

