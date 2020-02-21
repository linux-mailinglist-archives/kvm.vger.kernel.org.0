Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670821678ED
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 10:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbgBUJFP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 04:05:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45764 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727315AbgBUJFN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Feb 2020 04:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582275911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A7s/AuKmwFQf2sqfO4uUSGYKrB01ygBEp8/pgU2iE1I=;
        b=TYueL6cJSK+y3y8qaJ8ZfY+YG0RYgh5mAGnkCgqIhpp9Lc0fauiETsuuoKzsYvGA3P7H6E
        2dpfxt6BeHBfO9lWwTUvUvLna0NAYRNwu9vxmfHkiWB3vDdwKOwbaK9JnfABP83p9AwRwU
        CeoIbUMGfpgc9RbWU/auUI3MfT1Vsyg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-NkJkfxqyN2i3o4VLbL7rBg-1; Fri, 21 Feb 2020 04:05:09 -0500
X-MC-Unique: NkJkfxqyN2i3o4VLbL7rBg-1
Received: by mail-wr1-f69.google.com with SMTP id l1so747514wrt.4
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 01:05:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A7s/AuKmwFQf2sqfO4uUSGYKrB01ygBEp8/pgU2iE1I=;
        b=cXZb3riitFo0231S9yBZVQmfxqa+eXUkRhFYm/nW5VGdWiOie+uoytzPMA3Da2Egqh
         pk2zJLahzL3xKAR/B4IAc8uMUUfGBtr0chY0H/inJ35e5+ETujy2mws9MqEMLnejrtWd
         kaUDnb5+S/sQoY6iMd+Z19ZKO285yu0FNBSElUA90LE0CYlotrE8fRrFeGHPeSf3ipBn
         I80E4Jl6qO6d9nLRofy7M/uzGsTGPLyQQnwmYh+ZW5VrVI4PDsP3kmdxFALeKp9dE/Fp
         zGg7+Yli2xkGpAU9E1UbR9vlkJoIRteaiMGr6h7qklQcKfWqFgzml+3+PPUqGlyi4mkA
         V4Mg==
X-Gm-Message-State: APjAAAWoqe0IE7HRdlEThT+6EP6o5BJhNZfXV3SgmTKpFde/ONS/9IVd
        pm+b6W55SCKiF9ZDoW+ALsPerOltfcNYWBatVKTlc9a6TXHO/eLcF3ckx3eanXvsREZPCps+TG8
        HclazkKCOe8e6
X-Received: by 2002:a1c:f009:: with SMTP id a9mr2443036wmb.73.1582275908623;
        Fri, 21 Feb 2020 01:05:08 -0800 (PST)
X-Google-Smtp-Source: APXvYqwfgP9ZIAo+RGBG+fE7sgi6aJ5iK8F9+4avWIKxKhOLP/QG9udVgcEi8h8iXaivSGwfE6BSfQ==
X-Received: by 2002:a1c:f009:: with SMTP id a9mr2442970wmb.73.1582275908010;
        Fri, 21 Feb 2020 01:05:08 -0800 (PST)
Received: from [192.168.178.40] ([151.20.135.128])
        by smtp.gmail.com with ESMTPSA id l15sm3115011wrv.39.2020.02.21.01.05.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 01:05:07 -0800 (PST)
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
To:     Oliver Upton <oupton@google.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm list <kvm@vger.kernel.org>
References: <20200218184756.242904-1-oupton@google.com>
 <20200218190729.GD28156@linux.intel.com>
 <f08f7a3b-bd23-e8cd-2fd4-e0f546ad02e5@redhat.com>
 <CAOQ_Qshafx78-O4_HnK9MbOdmoBdZx6_sdAdLmugmXjURTXs6g@mail.gmail.com>
 <096c6b94-c629-7082-cd70-ab59fedffa7c@redhat.com>
 <CAOQ_QshfVkvSG==rCbROaZ0E6V0s5gTQtcfnDSV-Ar5-jv-Cbg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b1ad977a-02ba-2471-0065-6b1762964897@redhat.com>
Date:   Fri, 21 Feb 2020 10:05:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <CAOQ_QshfVkvSG==rCbROaZ0E6V0s5gTQtcfnDSV-Ar5-jv-Cbg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/02/20 09:34, Oliver Upton wrote:
> Absolutely. I thought it sensible to send out the fix in case of other
> toolchains out in the wild. But if nobody else other than us has
> complained it's quite obvious where the problem lies.

Here is another plausible (and untested) way to fix it, in case it's
the alias analysis that is throwing off the compiler (plus possibly
__always_inline).

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 027259af883e..63c7dcd7c57f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2218,6 +2218,8 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
 	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
 	gfn_t nr_pages_avail;
+	unsigned long hva;
+	struct kvm_memslot *memslot;
 
 	/* Update ghc->generation before performing any error checks. */
 	ghc->generation = slots->generation;
@@ -2231,19 +2233,22 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 	 * If the requested region crosses two memslots, we still
 	 * verify that the entire region is valid here.
 	 */
-	for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {
-		ghc->memslot = __gfn_to_memslot(slots, start_gfn);
-		ghc->hva = gfn_to_hva_many(ghc->memslot, start_gfn,
-					   &nr_pages_avail);
-		if (kvm_is_error_hva(ghc->hva))
+	do {
+		memslot = __gfn_to_memslot(slots, start_gfn);
+		hva = gfn_to_hva_many(memslot, start_gfn, &nr_pages_avail);
+		if (kvm_is_error_hva(hva))
 			return -EFAULT;
-	}
+		start_gfn += nr_pages_avail;
+	} while (start_gfn <= end_gfn);
 
 	/* Use the slow path for cross page reads and writes. */
-	if (nr_pages_needed == 1)
-		ghc->hva += offset;
-	else
+	if (nr_pages_needed == 1) {
+		ghc->hva = hva + offset;
+		ghc->memslot = memslot;
+	} else {
+		ghc->hva = 0;
 		ghc->memslot = NULL;
+	}
 
 	ghc->gpa = gpa;
 	ghc->len = len;

Paolo

