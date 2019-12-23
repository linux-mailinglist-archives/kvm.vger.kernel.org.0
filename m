Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEF3B1299AF
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 18:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfLWR7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 12:59:03 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23009 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726787AbfLWR7A (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Dec 2019 12:59:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577123938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=STtzNyT0+MBoIozU3+6g5UpNJ/WCnDF9rLCyPLhJAF4=;
        b=FQtjLMBEmrRF0x3jh110eN/4lw8TxM5EJkuplY66ECOejmFfm7LZUyjBH3a02WsJRsB3tL
        4S/MWMWpT9MuzX5WSRcR7inKgBfN26naXjWmpyPeSNnDhAIk+iO5QfiAeWrMsKVOxYhJWY
        t5UOuY9CSpWdXo9mFxYdjpKW7XYLlLo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-421-wW1HyCb_MsqJGsEmhN5QTA-1; Mon, 23 Dec 2019 12:58:57 -0500
X-MC-Unique: wW1HyCb_MsqJGsEmhN5QTA-1
Received: by mail-wr1-f70.google.com with SMTP id f15so2850082wrr.2
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2019 09:58:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=STtzNyT0+MBoIozU3+6g5UpNJ/WCnDF9rLCyPLhJAF4=;
        b=e2os/YwB8kolBgoTLD+FCM60lDdKvqv+8/7VOr3tU2UoYiMn2WrumVssOwORhFLiDu
         6Krx5YjkEZNwhVuWfSUbIqgOWWmeU41mcoU4GXENEKZencs2U5izPEwABxptmp/G2FJe
         jp4Io6MJazWonbnSnLrnEGmLRnr4B+yIfCoDi9fUNnsf714kp3oOyQpRkga1/E6yuiP9
         DX194NMWr1pkpKwAoyg8DJWdWw/3jUjTealUKtZJK44qpxxcY9wVY9QDx1+w9c8uLgfV
         QDiNXSrdCseIiXp4kuBOUxi53DJHhs52u+xdFJzJgYB5FlvHyYdQRqxEzwGYetWybFH0
         oGqA==
X-Gm-Message-State: APjAAAUZBUDMolI5oe8niCW22uov8nTxojSos+HES+h+tVAdh7x94K/l
        k6VBMvdzD8ysPYrzKRwIMtB1SzI/BPW5Y0dysDlzUObZdjnD2LPJRCOIWJikLu9YtubcwQslCUf
        /IerfnatgdosF
X-Received: by 2002:a7b:c342:: with SMTP id l2mr152091wmj.159.1577123936648;
        Mon, 23 Dec 2019 09:58:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqykiqSXU2vl/R+wx6gf5ATr2f0hU8N+owgQTSrl/A5u9oYsJ4rRsDFfA7QvqN0uWBs9340ziw==
X-Received: by 2002:a7b:c342:: with SMTP id l2mr152075wmj.159.1577123936420;
        Mon, 23 Dec 2019 09:58:56 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ac09:bce1:1c26:264c? ([2001:b07:6468:f312:ac09:bce1:1c26:264c])
        by smtp.gmail.com with ESMTPSA id n1sm20832083wrw.52.2019.12.23.09.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 09:58:55 -0800 (PST)
Subject: Re: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
 <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
 <20191223172737.GA81196@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <851bd9ed-3ff3-6aef-725c-b586d819211c@redhat.com>
Date:   Mon, 23 Dec 2019 18:59:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191223172737.GA81196@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/19 18:27, Peter Xu wrote:
> Yes.  Though it is a bit tricky in that then we'll also need to make
> sure to take slots_lock or srcu to protect that hva (say, we must drop
> that hva reference before we release the locks, otherwise the hva
> could gone under us, iiuc).

Yes, kvm->slots_lock is taken by x86_set_memory_region.  We need to move
that to the callers, of which several are already taking the lock (all
except vmx_set_tss_addr and kvm_arch_destroy_vm).

Paolo

> So if we want to do that we'd better
> comment on that hva value very explicitly, just in case some future
> callers of __x86_set_memory_region could cache it somewhere.

