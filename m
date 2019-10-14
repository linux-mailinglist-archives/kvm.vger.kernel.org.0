Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38904D6457
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2019 15:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732255AbfJNNsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 09:48:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732077AbfJNNsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 09:48:32 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C70A9A707;
        Mon, 14 Oct 2019 13:48:31 +0000 (UTC)
Received: from gondolin (dhcp-192-233.str.redhat.com [10.33.192.233])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4BBCF1001B03;
        Mon, 14 Oct 2019 13:48:27 +0000 (UTC)
Date:   Mon, 14 Oct 2019 15:48:25 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tianyu Lan <Tianyu.Lan@microsoft.com>
Cc:     vkuznets <vkuznets@redhat.com>,
        "lantianyu1986@gmail.com" <lantianyu1986@gmail.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rth@twiddle.net" <rth@twiddle.net>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: Re: [PATCH] target/i386/kvm: Add Hyper-V direct tlb flush support
Message-ID: <20191014154825.7eb5017d.cohuck@redhat.com>
In-Reply-To: <KL1P15301MB02611D1F7C54C4A599766B8D92900@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
References: <20191012034153.31817-1-Tianyu.Lan@microsoft.com>
        <87r23h58th.fsf@vitty.brq.redhat.com>
        <KL1P15301MB02611D1F7C54C4A599766B8D92900@KL1P15301MB0261.APCP153.PROD.OUTLOOK.COM>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 14 Oct 2019 13:48:31 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 14 Oct 2019 13:29:12 +0000
Tianyu Lan <Tianyu.Lan@microsoft.com> wrote:

> > > diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> > > index 18892d6541..923fb33a01 100644
> > > --- a/linux-headers/linux/kvm.h
> > > +++ b/linux-headers/linux/kvm.h
> > > @@ -995,6 +995,7 @@ struct kvm_ppc_resize_hpt {
> > >  #define KVM_CAP_ARM_SVE 170
> > >  #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
> > >  #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
> > > +#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 174  
> >
> > I was once told that scripts/update-linux-headers.sh script is supposed
> > to be used instead of cherry-picking stuff you need (adn this would be a
> > separate patch - update linux headers to smth).
> >  
> 
> Thanks for suggestion. I just try the update-linux-headers.sh and there are a lot
> of changes which are not related with my patch. I also include these
> changes in my patch, right?

The important part is that you split out the headers update as a
separate patch.

If this change is already included in the upstream kernel, just do a
complete update via the script (mentioning the base you did the update
against.) If not, include a placeholder patch that can be replaced by a
real update when applying.
