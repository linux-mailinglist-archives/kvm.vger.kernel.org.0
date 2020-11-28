Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436132C768F
	for <lists+kvm@lfdr.de>; Sun, 29 Nov 2020 00:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgK1XRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 18:17:45 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48706 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgK1XRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 18:17:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ASNARoq155102;
        Sat, 28 Nov 2020 23:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=WaJiSii+zp2LvXv7ymV3Ze5LFnN0sUhCPiictqURKYw=;
 b=x7W7MHh7STSNvloWi61erbJMfKJB064+PbtGTX1rqTuoYCKfXpF4+hS0YHgd11rY4IZA
 stkIP1YHPyITeN6dECugSSMmftMyj/OB7BsbmhgjRh1kSOxsRjwMJ5MgS8Q5qZeMVKCR
 QA9v7UVzIh1dMPhhD90AJfjg0U3VpNWFtQ2+keaBY1x4OIrSsnmyiebOUv6vqSwuYtzm
 WlWTURfJyateznkXjgOdGNgFX2fqR5mgfm/tYll8F+xPxI/6mdEu+XXCcAYGzbOPs7T9
 yRi7RG/Q9Hz67ipOO6Hm9OfqjJrn9XuwDGXyB67WDQ+lNEeZHruGKeMOnVDwE3CgDhvg XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 353c2ahf9p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 28 Nov 2020 23:16:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ASNA8dX195347;
        Sat, 28 Nov 2020 23:16:55 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 353dvj0hb7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Nov 2020 23:16:55 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ASNGsYU020171;
        Sat, 28 Nov 2020 23:16:54 GMT
Received: from [192.168.1.67] (/94.61.1.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 28 Nov 2020 15:16:54 -0800
Subject: Re: [PATCH] KVM: x86: Reinstate userspace hypercall support
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <3b9987c6-0d91-177c-7f44-0984dc586253@oracle.com>
Date:   Sat, 28 Nov 2020 23:16:51 +0000
MIME-Version: 1.0
In-Reply-To: <1bde4a992be29581e559f7a57818e206e11f84f5.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9819 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 mlxlogscore=959 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011280149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9819 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 clxscore=1011 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011280149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey David,

On 11/28/20 2:20 PM, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> For supporting Xen guests we really want to be able to use vmcall/vmmcall
> for hypercalls as Xen itself does. Reinstate the KVM_EXIT_HYPERCALL
> support that Anthony ripped out in 2007.
> 
> Yes, we *could* make it work with KVM_EXIT_IO if we really had to, but
> that makes it guest-visible and makes it distinctly non-trivial to do
> live migration from Xen because we'd have to update the hypercall page(s)
> (which are at unknown locations) as well as dealing with any guest RIP
> which happens to be *in* a hypercall page at the time.
> 

I don't know how far you've gone on your implementation but in the past I had
send a series for Xen guests support (and backends/uabi too), hopefully
you find that useful and maybe part of that could be repurposed?

https://lore.kernel.org/kvm/20190220201609.28290-1-joao.m.martins@oracle.com/

(The link above has links towards userland parts albeit you probably don't
care about Qemu)

While it looks big at the first sight ... in reality out of the 39 patches,
only the first 16 patches implement the guest parts [*] while reusing the
XEN_HVM_CONFIG for the xen hypercall page MSR. Assuming the userspace VMM
does most device emulation including xenbus handling.

Also assumes one uses the xen shim for PV guests support.

	Joao

[*] Largely for guest performance as event channel IPIs in userspace with
split irqchip weren't the fastest IIRC ... would have to dig the numbers;
