Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECB52D3DF9
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 09:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgLIIxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 03:53:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47222 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725942AbgLIIxs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 03:53:48 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B98VsfV151070
        for <kvm@vger.kernel.org>; Wed, 9 Dec 2020 03:53:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=M3WnWCIkJW3i2/cgsLIviF2dPBwo/hdv+5hpUIECn2c=;
 b=BRIXPdjuGGRZfxiqz5qhZyatNoy54W7sVJAl7FyWrhFyh5EbIi4UBb75brIeoD9wHbVj
 uusI9TIaTPjRWEugB/kGs3WgB4xZNHB5E6YtaQ+jhtPKhVoLTsUJrhciJGaG0A2Ze3DX
 2zgXyK3qTEUI+WG+wtEu2tPh9jrAeYaUDlt0sIpoueDLKGLwDkmmpjrXsUeduNBdJq5z
 aDpsAfkroiYiSnQzamujyZG8yRGB/VoDvF4nWFGT18tBlqdvQVEfet+0bkHdivaHmbsu
 OMnuJVBaOa31mVYjI0aqQtn+TUKhzNrz4f6Y94JWp3xEF3FmwTQWyxWnCGnY2M4u5jmL Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35amch2cvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 09 Dec 2020 03:53:07 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B98VrRp150894
        for <kvm@vger.kernel.org>; Wed, 9 Dec 2020 03:53:06 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35amch2cvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 03:53:06 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B98qDv4016443;
        Wed, 9 Dec 2020 08:53:05 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3581u8pga8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 08:53:04 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B98r2eD17694998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 08:53:02 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7F1AAA4051;
        Wed,  9 Dec 2020 08:53:02 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0DA97A404D;
        Wed,  9 Dec 2020 08:53:02 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.3.233])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 08:53:01 +0000 (GMT)
Date:   Wed, 9 Dec 2020 09:53:00 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Nadav Amit <nadav.amit@gmail.com>, KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, cohuck@redhat.com,
        lvivier@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib/alloc_page: complete rewrite
 of the page allocator
Message-ID: <20201209095300.37f1ce99@ibm-vm>
In-Reply-To: <20201208142610.sp3ytst6jlelbzxy@kamzik.brq.redhat.com>
References: <20201002154420.292134-1-imbrenda@linux.ibm.com>
        <20201002154420.292134-5-imbrenda@linux.ibm.com>
        <C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com>
        <11863F45-D4E5-4192-9541-EC4D26AC3634@gmail.com>
        <20201208101510.4e3866dc@ibm-vm>
        <A32A8A40-5581-4A3D-9DC8-4591C3A034C7@gmail.com>
        <20201208110010.7d05bd3a@ibm-vm>
        <7D823148-A383-470A-9611-E77C2E442524@gmail.com>
        <20201208144139.1054d411@ibm-vm>
        <20201208142610.sp3ytst6jlelbzxy@kamzik.brq.redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_07:2020-12-08,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=873
 priorityscore=1501 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 impostorscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090056
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Dec 2020 15:26:10 +0100
Andrew Jones <drjones@redhat.com> wrote:

[...]
 
> > > are not apparent when the memory is zeroed. I do not think anyone
> > > wants to waste time on resolving these bugs.  
> > 
> > I disagree. if a unit test has a bug, it should be fixed.
> > 
> > some tests apparently need the allocator to clear the memory, while
> > other tests depend on the memory being untouched. this is clearly
> > impossible to solve without some kind of switch
> > 
> > 
> > I would like to know what the others think about this issue too
> >  
> 
> If the allocator supports memory being returned and then reallocated,
> then the generic allocation API cannot guarantee that the memory is
> untouched anyway. So, if a test requires untouched memory, it should
> use a specific API. I think setup() should probably just set some
> physical memory regions aside for that purpose, exposing them somehow
> to unit tests. The unit tests can then do anything they want with
> them. The generic API might as well continue zeroing memory by
> default.

I think I have an idea for a solution that will allow for untouched
pages and zeroed pages, on request, without any additional changes.

Give me a few days ;)

> I never got around to finishing my review of the memory areas. Maybe
> that can be modified to support this "untouched" area simply by
> labeling an area as such and by not accepting returned pages to that
> area.
> 
> Thanks,
> drew
> 

