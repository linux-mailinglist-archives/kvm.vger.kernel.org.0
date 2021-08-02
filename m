Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7EA3DDDD6
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhHBQjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:39:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230030AbhHBQjV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 12:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627922351;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=93WN2042m3rjohEx9xyQXlXemLZSv5wLxkPdJJU80kc=;
        b=K8IiNhNJBIt3foZ7FJGwHCrGPm9BrZ/Em2N+m6Ot94yNgNFYCn7DyhSKJ3ZWe4diX6z1kG
        iUTiST54JSRPMKADlj2Wg2N8j8u5QR5Wy+K3Q9vBi++wH9hsVVac8+lhI727rqZ368xnR9
        pSuw8U/SLRJyusfr/UT/++paI+/gm5o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-E7Z6QgTZOUmI3QidATSjQQ-1; Mon, 02 Aug 2021 12:39:08 -0400
X-MC-Unique: E7Z6QgTZOUmI3QidATSjQQ-1
Received: by mail-wm1-f70.google.com with SMTP id 85-20020a1c01580000b02902511869b403so5249132wmb.8
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=93WN2042m3rjohEx9xyQXlXemLZSv5wLxkPdJJU80kc=;
        b=AyLWWZDUfs1wm5MsYoLy+SFjoXwnaldsJj+XEkCeLixMy8K/bAYF9YpFWGMY6TEegi
         lrstYeqQhBIMeZRwVjPX/1mYKroxMZQ3C3Mjj57EhmCdTpVTA0WpKBa9fCyBK1NB3fAe
         dLKfoRDGv7lbasYJtA+E68BzDTK0o+N3RW04sEhgH1M//3/DVvVuUDhk9fi7V8gTA2eN
         nBk8bhLYuiYeUdGFb7ILvSkZ/FLV15jMoPoYyFRVXwTVLbx/EvVg3pAHXZQ0Cz3gOCEF
         bhpS023RrnzS7I0yNdKlsAwbFkj7A5jwhl4PoyN1g5Yp343MSwPauWOGXRWBEsM+9TJK
         1hFQ==
X-Gm-Message-State: AOAM5305PNAvKheQsgkFWBmooJDyj6xtCaYlf3fAdJ2SD6Nk525SLhMm
        4lRTPykQbuYHApxw6IL2+uEWsCLV8TEzyDRFb/hPyTuJSen7hv/kz4Bv7uZBQSWtKE7rMnmTZvt
        sF/Qvz054OEpV
X-Received: by 2002:a5d:55cb:: with SMTP id i11mr18478950wrw.158.1627922347173;
        Mon, 02 Aug 2021 09:39:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwjK6h6Ujxt1OrsnDRb/OQy6coA3LfxauFjVsw9ozQcdPW5ii8YKRKOORjxcf3DEZezUehA1w==
X-Received: by 2002:a5d:55cb:: with SMTP id i11mr18478934wrw.158.1627922347002;
        Mon, 02 Aug 2021 09:39:07 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b6sm13566366wrn.9.2021.08.02.09.39.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 09:39:06 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: nSVM: Show guest mode in kvm_{entry,exit}
 tracepoints
To:     Sean Christopherson <seanjc@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org,
        jmattson@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        joro@8bytes.org
References: <20210621204345.124480-1-krish.sadhukhan@oracle.com>
 <20210621204345.124480-2-krish.sadhukhan@oracle.com>
 <ac5d0cb7-9955-0482-33ee-cf06bb55db7a@redhat.com>
 <YQgeoOpaHGBDW49Z@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <68082174-4137-db39-362c-975931688453@redhat.com>
Date:   Mon, 2 Aug 2021 18:39:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQgeoOpaHGBDW49Z@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 18:34, Sean Christopherson wrote:
> On Mon, Aug 02, 2021, Paolo Bonzini wrote:
>> On 21/06/21 22:43, Krish Sadhukhan wrote:
>>> With this patch KVM entry and exit tracepoints will
>>> show "guest_mode = 0" if it is a guest and "guest_mode = 1" if it is a
>>> nested guest.
>>
>> What about adding a "(nested)" suffix for L2, and nothing for L1?
> 
> That'd work too, though it would be nice to get vmcx12 printed as well so that
> it would be possible to determine which L2 is running without having to cross-
> reference other tracepoints.

Yes, it would be nice but it would also clutter the output a bit.
It's like what we have already in kvm_inj_exception:

         TP_printk("%s (0x%x)",
                   __print_symbolic(__entry->exception, kvm_trace_sym_exc),
                   /* FIXME: don't print error_code if not present */
                   __entry->has_error ? __entry->error_code : 0)

It could be done with a trace-cmd plugin, but that creates other issues since
it essentially forces the tracepoints to have a stable API.

Paolo

