Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68121152A00
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgBELhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:37:17 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58643 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727970AbgBELhQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 06:37:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580902635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jei7ECG4yc8A3mSpo/uZqlsvyCFd/LIQUOwIuTlbz+M=;
        b=W9abezW15PX996UPzue0F4wfu/UU6HX1nnHA2uKqGNyNNpvB+xiXjLqNNE3T9z/h4Jne/J
        oFBMpOIU5iSXZc6sgcpboAFUteB7b9jsaG93Oiyeorp0iCDuIsmtqr03Q04SDgGngtvfic
        MROcqY7Gjsq91/e9mpCq4xCLzHgruVw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-tgTP_iSVN3yAJmA7lp0hZA-1; Wed, 05 Feb 2020 06:37:14 -0500
X-MC-Unique: tgTP_iSVN3yAJmA7lp0hZA-1
Received: by mail-wr1-f70.google.com with SMTP id d15so1062030wru.1
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 03:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jei7ECG4yc8A3mSpo/uZqlsvyCFd/LIQUOwIuTlbz+M=;
        b=TwI1tVXqJm3olZCs0/aFeUAJAy+V6HVmw+3wl59I1tqO9ywW8qtldtSPaMDA/V/7rX
         QXCryGlyYwhCyvcWmOiNb2kGCEbFenqtdp1gH+gIlvIyLJ+6Rv2TmU1/I5yZ5Evy+kPD
         7Ne+4W5i3ddnIAuVoKfgItx8/Awrb5p57thAMRw0Zt1k4pMSxGwVtxFKkZLbAFHhyjPQ
         yA3XIBlclOGVfYmsb22XdIeprWyqZKrqrZkWGSsVyuqVG0gNacv1oEitoYYivOS7Ohjj
         Rbq/9ZKmsinMh2T458Wu94t1sZPYpPXPT6xtgBLPm2cCVpJyinypqWujVJjgBPHYGVj3
         HQ3A==
X-Gm-Message-State: APjAAAWWxnU3siXcUOt3b6jk73Kw14cOHItqQDVHtWEf1/2101iuObqt
        rOqBNWZSddsldRwENC5c9WwenYJ8QA08b9Xo4lvSgoVBjOMTqhDHROhoncbw30VFSgEY0H21juP
        /d7x7V2OwEZfv
X-Received: by 2002:a7b:c7c9:: with SMTP id z9mr5535186wmk.175.1580902633129;
        Wed, 05 Feb 2020 03:37:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqw6ocmE/JEX9Iz0I7VYk0dKse3JrUpXiJlRzp2isq7de0EZTsIRyrumCezCETCT7yTsnF1WiA==
X-Received: by 2002:a7b:c7c9:: with SMTP id z9mr5535168wmk.175.1580902632890;
        Wed, 05 Feb 2020 03:37:12 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k16sm36707227wru.0.2020.02.05.03.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 03:37:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] x86: Use "-cpu host" for PCID tests
In-Reply-To: <20200204194809.2077-1-sean.j.christopherson@intel.com>
References: <20200204194809.2077-1-sean.j.christopherson@intel.com>
Date:   Wed, 05 Feb 2020 12:37:11 +0100
Message-ID: <874kw5mfiw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use the host CPU model for the PCID tests to allow testing the various
> combinations of PCID and INVPCID enabled/disabled without having to
> manually change the kvm-unit-tests command line.  I.e. give users the
> option of changing the command line *OR* running on a (virtual) CPU
> with or without PCID and/or INVPCID.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/unittests.cfg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index aae1523..25f4535 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -228,7 +228,7 @@ extra_params = --append "10000000 `date +%s`"
>  
>  [pcid]
>  file = pcid.flat
> -extra_params = -cpu qemu64,+pcid
> +extra_params = -cpu host
>  arch = x86_64
>  
>  [rdpru]

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Actually, is there any reason for *not* using '-cpu host' in any of the
tests?

-- 
Vitaly

