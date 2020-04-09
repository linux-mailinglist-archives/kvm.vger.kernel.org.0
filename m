Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF0E1A3471
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 14:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgDIM5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 08:57:32 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50976 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726609AbgDIM5c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 08:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586437051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O2CLuS3FEdpoO51mMdiV5dcccG5OKJkGsbzDxdCTFJc=;
        b=S/Xi80WEpWmwWIAtuePSpP00yDxQZDtiEd8wZPUgE0yEn1Y8n/KwxygjtrE37gaP8yRi7Y
        pscJqULCxQmsjIsfx9/5XjPtLwXxmqDMZ8VnvbLa9NxcDl8igjoG8x3toS4SV7+aeULF6D
        FKOAvPPDl5cOtGCN48GMiV+xseW3Ejo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-aCVDYKQlOD2fSBBkaINFYA-1; Thu, 09 Apr 2020 08:57:29 -0400
X-MC-Unique: aCVDYKQlOD2fSBBkaINFYA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 09FF0801E5E;
        Thu,  9 Apr 2020 12:57:28 +0000 (UTC)
Received: from localhost (ovpn-12-133.pek2.redhat.com [10.72.12.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E19905C64E;
        Thu,  9 Apr 2020 12:57:21 +0000 (UTC)
Date:   Thu, 9 Apr 2020 20:57:19 +0800
From:   Baoquan He <bhe@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        dzickus@redhat.com, dyoung@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 0/3] KVM: VMX: Fix for kexec VMCLEAR and VMXON cleanup
Message-ID: <20200409125719.GV2402@MiWiFi-R3L-srv>
References: <20200321193751.24985-1-sean.j.christopherson@intel.com>
 <20200407110115.GA14381@MiWiFi-R3L-srv>
 <87r1wzlcwn.fsf@vitty.brq.redhat.com>
 <20200408151808.GS2402@MiWiFi-R3L-srv>
 <87mu7l2256.fsf@vitty.brq.redhat.com>
 <20200409012002.GT2402@MiWiFi-R3L-srv>
 <87imi829o9.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imi829o9.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/20 at 01:14pm, Vitaly Kuznetsov wrote:
> Baoquan He <bhe@redhat.com> writes:
> 
> >
> > While I would suggest adding kexec@lists.infradead.org when code changes
> > are related to kexec/kdump since we usually watch this mailing list.
> > LKML contains too many mails, we may miss this kind of change, have to
> > debug and test again.
> >
> 
> Definitely makes sense and I'll try my best to remember doing this
> myself next time but the problem is that scripts/checkpatch.pl is not
> smart enough, kexec related bits are scattered all over kernel and
> drivers so I'm afraid you're missing a lot in kexec@ :-(

Yeah, understand, thanks.

