Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921A123D481
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 02:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgHFASv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 20:18:51 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38402 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726401AbgHFASs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Aug 2020 20:18:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596673127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MJRT7zSpZFX2l/kmuMRr1EyvfjsdpbwTsB/NIpr52Vg=;
        b=cBZYcA/7GAHNRRzBsyALhyCDGRM+oTxLJqWppDijrE9N3KA/BOpyQxDYcKWo1TH8kD28vS
        ndT4KdpUtRXKrhle+m2LJTKtYbCf8QEtLqzofr5tI5UBLN5MnoCGp97kcjilqd+zeC7uJa
        WLB6FhyrpdMECXDPzU18TjSRiyGeSZE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-MnlcE6_NMjimNC79pnar9w-1; Wed, 05 Aug 2020 20:18:43 -0400
X-MC-Unique: MnlcE6_NMjimNC79pnar9w-1
Received: by mail-wm1-f70.google.com with SMTP id u144so3388210wmu.3
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 17:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MJRT7zSpZFX2l/kmuMRr1EyvfjsdpbwTsB/NIpr52Vg=;
        b=sp1QF1UpGw7uUOnVVKbMYqlfwVH43pymW2SFOdfz1k58QEspp7O23FJwsbud8TtCS7
         q1hceZ7/Aj9koVepuD2UAyqKH36Pzxk+fkv2dznsvYglteJ+2TeWwePE8i9nob3LRr1E
         aisBuLHoMNAAUC8PwE0meFPy+7FG8e4fyMpSH7t4cb/1tVFkOsdetgUMN2c1ZsWuzhQE
         bNzKKWc9saWqDG3uy2G+z+DB0MOPjDZljpYZ+0mKJaVfApAwYGbCqKGu3MUJ8moNsllA
         dq/AwGc3GHTvwZbWUA35aZsAZHLhsVW+3NBHS0FT7zm9pMK0QF8kz7HbHr58BgQI0GJx
         gpgA==
X-Gm-Message-State: AOAM531UDlNXYKitLE5lje9fZxj6bst39YKLh9bjS1ivdQxAbeaPl0di
        FeDjr7L+ecO2fAQ0AZK2vaES6aZINUtDxZO9bnHaSTdvdgw7mdemO7XvgmStalZjRcO3HCCDwDN
        j/FCPDPJkkZe4
X-Received: by 2002:a05:6000:120c:: with SMTP id e12mr4761716wrx.354.1596673122253;
        Wed, 05 Aug 2020 17:18:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIUgCo8JmpOWMKH0QebbmqgBGb/LD/AwNZ3OZiBAbeJF9gifgU0NvT9R6cIHZlnE7BhL8MxA==
X-Received: by 2002:a05:6000:120c:: with SMTP id e12mr4761704wrx.354.1596673122078;
        Wed, 05 Aug 2020 17:18:42 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id g3sm5035425wrb.59.2020.08.05.17.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 17:18:41 -0700 (PDT)
Date:   Wed, 5 Aug 2020 20:18:37 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
Message-ID: <20200805201702-mutt-send-email-mst@kernel.org>
References: <20200728143741.2718593-1-vkuznets@redhat.com>
 <20200728143741.2718593-3-vkuznets@redhat.com>
 <CALMp9eSWsvufDXMuTUR3Fmh91O7tHUaqpDbAoavSMc=prpcDzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eSWsvufDXMuTUR3Fmh91O7tHUaqpDbAoavSMc=prpcDzg@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 05, 2020 at 10:05:40AM -0700, Jim Mattson wrote:
> On Tue, Jul 28, 2020 at 7:38 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >
> > PCIe config space can (depending on the configuration) be quite big but
> > usually is sparsely populated. Guest may scan it by accessing individual
> > device's page which, when device is missing, is supposed to have 'pci
> > hole' semantics: reads return '0xff' and writes get discarded. Compared
> > to the already existing KVM_MEM_READONLY, VMM doesn't need to allocate
> > real memory and stuff it with '0xff'.
> 
> Note that the bus error semantics described should apply to *any*
> unbacked guest physical addresses, not just addresses in the PCI hole.
> (Typically, this also applies to the standard local APIC page
> (0xfee00xxx) when the local APIC is either disabled or in x2APIC mode,
> which is an area that kvm has had trouble with in the past.)

Well ATM from KVM's POV unbacked -> exit to userspace, right?
Not sure what you are suggesting here ...

-- 
MST

