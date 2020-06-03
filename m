Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3331ECE40
	for <lists+kvm@lfdr.de>; Wed,  3 Jun 2020 13:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgFCLZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jun 2020 07:25:43 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29793 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725833AbgFCLZn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Jun 2020 07:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591183541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5hUqvEypAYJ+EhHqPgdxr7FIiIDs5UzhKV+cTFMQs/o=;
        b=FVH3nLjmSbbd0HeRYtYW5UmX6HTZtJqYkxRT456IR5O2jPKdC79ofGgqQJyyxDuSpL/RMt
        NWCw+KQDxd65fyeQdKB1n+50tBmKTzje1i++OuZywx3kr6gjebKRwNDChid00ZZEPdexd6
        +AWzo5/qwxlQw0Es1aSXDa+mTzSa7Gc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-WE2jn6anPdKfVPNN5jwzTw-1; Wed, 03 Jun 2020 07:25:40 -0400
X-MC-Unique: WE2jn6anPdKfVPNN5jwzTw-1
Received: by mail-wm1-f69.google.com with SMTP id l26so760022wmh.3
        for <kvm@vger.kernel.org>; Wed, 03 Jun 2020 04:25:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5hUqvEypAYJ+EhHqPgdxr7FIiIDs5UzhKV+cTFMQs/o=;
        b=EZR5MGAur74K0jQrdIcgPgXxjSrAS1kgszgLMRcMky5arbZ0ODfKOK7txg6Zy02wOg
         igyAP1vA74UvFl+aUCA2pGnGWie498aH97b/fyYGEh0zAaz8FSkUaAq8SHHEtVc2c6LR
         pWK7Ls+Eog/yw3gGFrXldpD1IGQ9vrdOVzlJCn0FlTqY3Rb1AHlXCDveFcIQyGED53ls
         Ws41d63/qvZHMuitbMAnBrcCIVzMZrluinf5sFKHdsCGnGsNOvdbMESMmGkl962oWs4o
         euIEvSWhLyvdlMctfR3byjJKuD+4ypsm0iWVfTLcGZvN5L6dWyByzgn05t2O5X/B91ud
         W6LQ==
X-Gm-Message-State: AOAM530P31PlunrmGfwOxZ8g19E9eQxvnJlRP31VbSA6/pxOXX/t2K+a
        xWfp1Oe2FGi5S44L2gWKeQVhvdFPV1YBoa9pNCKkQGSEV6aGwWEWtF/DqaZbo5weUhsnE+UNucJ
        PTQIMpAunZIqW
X-Received: by 2002:a1c:658a:: with SMTP id z132mr8202677wmb.20.1591183539002;
        Wed, 03 Jun 2020 04:25:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx3aHDNoBHLnPkiU+YgTd1MbOmkx3c/fv7aHCE9L/C62XG6RF9FKzQTZ7qsio+lIYqpmoJeRg==
X-Received: by 2002:a1c:658a:: with SMTP id z132mr8202664wmb.20.1591183538783;
        Wed, 03 Jun 2020 04:25:38 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.243.176])
        by smtp.gmail.com with ESMTPSA id t189sm2549806wma.4.2020.06.03.04.25.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2020 04:25:38 -0700 (PDT)
Subject: Re: [bug report] KVM: x86: enable event window in
 inject_pending_event
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org
References: <20200603103415.GC1845750@mwanda>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6c476bb5-cf85-ddb7-aaf1-0ac290bf9dfa@redhat.com>
Date:   Wed, 3 Jun 2020 13:25:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200603103415.GC1845750@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/06/20 12:34, Dan Carpenter wrote:
> Hello Paolo Bonzini,
> 
> The patch c9d40913ac5a: "KVM: x86: enable event window in
> inject_pending_event" from May 22, 2020, leads to the following
> static checker warning:
> 
> 	arch/x86/kvm/x86.c:10530 kvm_can_do_async_pf()
> 	warn: signedness bug returning '(-16)'
> 
> arch/x86/kvm/x86.c
>  10516  bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
>  10517  {
>  10518          if (unlikely(!lapic_in_kernel(vcpu) ||
>  10519                       kvm_event_needs_reinjection(vcpu) ||
>  10520                       vcpu->arch.exception.pending))
>  10521                  return false;
>  10522  
>  10523          if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
>  10524                  return false;
>  10525  
>  10526          /*
>  10527           * If interrupts are off we cannot even use an artificial
>  10528           * halt state.
>  10529           */
>  10530          return kvm_arch_interrupt_allowed(vcpu);
>  10531  }
> 
> The svm_nmi_allowed() used to return false because interrupts aren't
> allowed but now it returns -EBUSY so it returns true/allowed.

This is intentional (i.e. not a bug) but it should have an explicit "!= 0".

Paolo

