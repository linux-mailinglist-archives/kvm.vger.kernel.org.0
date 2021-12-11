Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5000D471126
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 04:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbhLKDRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 22:17:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235648AbhLKDRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 22:17:54 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515D1C061714
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 19:14:18 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id s11so10148183ilv.3
        for <kvm@vger.kernel.org>; Fri, 10 Dec 2021 19:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pifxhk+jLzs45Q6S6sqbJnAjA8dKjrzi4ZhpMrIdVbM=;
        b=F34jGX3p945QhEUOjHfLwJd41S10l7so9AfoIFe2vb2zbdFtTUBaBwyX2xFKerrme3
         hxE5KtqCBXr8h96d5G1BD2gu3zE5fvgSiJhK1g2PuR2/xepE3VroSzVFFKJGnns/Z1NC
         I7l1L3CoWqq20LjQ/9xNszXeArfjFiG7t4y+Ke/y9rwCfhkS2+aAGmxLOgmreeuiTTaD
         M3pwOAhTuoNbIfZ8zEJ6NwO+rFPb6NuwG9FYRsK4mH+yLZ4wfVuWGpH7UhmKApN1TCrT
         spNHZP09Kvi/UjZTarl0aeaN4EZalayFYDc1796lBhLMQHV3fiDDxY763kCuid3hewPy
         1aKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pifxhk+jLzs45Q6S6sqbJnAjA8dKjrzi4ZhpMrIdVbM=;
        b=t4u5CMyJeoQdQxETh5TKRCXJlKN/xBW85Za9lJZ+3c47x9UZLWbQOweT98dn40sGbS
         0tBiToDky93Xu1U5aMdFYstI1NW9kCx+q2LPokWmSA95Vgc4v5YCFBwvtteVQbuvBhDb
         heKjRKZhLzQcDoZpxCHnMMyzw42ap9OSvkjqUi6vEEkUpy0gcBNXU+/y7Ao0Uo4ZPHcZ
         rIIOuI0JT4UKE/YJNO678BhAvB+9IxnWDOkoHOdJdUpk2n8EDCiB+GMXX9FE3atFWUQA
         4NVDx4WHDUSCiSTY8MCb8hVRSHnQRHWQbL+Pj38ZhwvJBvZeTJRARhEuE0LOkrx9684g
         1U1g==
X-Gm-Message-State: AOAM531h7XY5tRcrC5D5REVhSOiPnTOCD37cm7Owey/txInYMXvpFCCC
        z52GNKrUjOm/Q3xuficbU/m2J14QoacedRTC+sI=
X-Google-Smtp-Source: ABdhPJyalRDbLY8/grFriOFVBSxjITx9j4Ad2M6fa+OfYQz3HgKUHgReY83bval2VqoHrLkSMJXSjovFHSsmvxZR76w=
X-Received: by 2002:a05:6e02:16ca:: with SMTP id 10mr22024179ilx.274.1639192457746;
 Fri, 10 Dec 2021 19:14:17 -0800 (PST)
MIME-Version: 1.0
References: <YbOVBDCcpuwtXD/7@google.com> <d22eb5e1-0e9d-707d-8482-c63857e87b0d@redhat.com>
 <76d5e958-af0b-68fb-e6fa-ecdab8d79eeb@redhat.com>
In-Reply-To: <76d5e958-af0b-68fb-e6fa-ecdab8d79eeb@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Sat, 11 Dec 2021 11:14:06 +0800
Message-ID: <CAJhGHyAsFgdrKz8e7SNC=9sVNbAa-LHOtExS7CAAHnbNfGPaEA@mail.gmail.com>
Subject: Re: VM_BUG_ON in vmx_prepare_switch_to_guest->__get_current_cr3_fast
 at kvm/queue
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Dec 11, 2021 at 10:01 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/11/21 01:11, Paolo Bonzini wrote:
> > Yeah, vmx_prepare_switch_to_guest() doesn't update HOST_CR3 if no
> > preemption happens from one call of vcpu_enter_guest() to the next
> > (preemption would cause a call to kvm_arch_vcpu_put and from there to
> > vmx_prepare_switch_to_host, which clears vmx->guest_state_loaded).
> >
> > During that time an MM switch is bumping the PCID; I would have expected
> > any such flush to require a preemption (in order to reach e.g.
> > switch_mm_irqs_off), but that must be wrong.  In the splat below in fact
> > you can see that the values are 0x60674f2005 (RAX) and 0x60674f2006 (RCX
> > and CR3).
>
> As Jiangshan said, the PCID is bumped while L2 runs, and is stale when
> switching back to the vmcs01.  That indeed is compatible with a
> preemption.  There should definitely be a comment in
> vmx_prepare_switch_to_guest() that points to vmx_sync_vmcs_host_state().
>


I think it would be better to rename vmx_set_host_fs_gs() to
vmx_set_vmcs_host_state() and it also handles for HOST_CR3.
And both vmx_prepare_switch_to_guest() and vmx_sync_vmcs_host_state()
will call vmx_set_vmcs_host_state().

Thanks
Lai
