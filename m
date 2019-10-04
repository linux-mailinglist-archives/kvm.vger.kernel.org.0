Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80F5BCB50D
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 09:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730311AbfJDHe1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 03:34:27 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27983 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727326AbfJDHe0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Oct 2019 03:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570174465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=OcXZK/E6XChoGriXNHisT5XgSISsNlmPOggtOuvsig4=;
        b=gCP5plUHPzIKmIGW/EX8pOjZYG0GEQrl2v8w4XHRlvRUMxi1Iqko/LmOeiISxJOvnvUpHT
        pOqRUlLVYp2yyZt0sVifndhB42qnWShx+KDsU2vMaD3sSdquefjAufhnPAcdS7OSlMxzxb
        qfmcgXrIIXKVGzCdeLmNTbSpAuwTfhY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-BQ2-Gv_PN8u_-B17CFKLag-1; Fri, 04 Oct 2019 03:34:22 -0400
Received: by mail-wm1-f70.google.com with SMTP id k184so2261283wmk.1
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 00:34:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XDtbjvAly1a3qucQKzKApj2XOLHI9VDInqQWVwE047w=;
        b=lSIJcKQ27vNVyjxEV2R7t3QwzySOFS5H+tog2TlvwIlnrog6P3CsYW/KzIS9+dhMuj
         g5GaES513VIaQqPZ+s7kTsON9fe1gMpjUNjFLxo9DBn1WhRO0d2QWTDsW/XMuJUp/5Qf
         ufQBoNktgeTW8+0ZbpkcbfozlqjkxqYe/acVlXSdIXvHVXu9N9uxe6bqhiITjENPcv9y
         KsVKHJz2NZ52EgVfcvBSYv/8yCh9LdqyDSq/7Jra8SdCE5q6GRL1N1ksuvSOyrlXLUxC
         SpNDQ+I+OSVNniWVr2Etp6Ya0HKhjycwwHnaCR/uPy2+f8bZLll369sS1a73ZtRMHD2M
         Pc7A==
X-Gm-Message-State: APjAAAVJWx0QxRqDDdXo7mwPSVzw+Ul79z8knqbb6Wk2y7b+V9hKcI0v
        Xs+w8jLYzCQs0xYCe06TIlGIyf6oxzXf7t/60NpClOR4xoZHhABwRGATAweZo5vNC0kd50JLjDJ
        fYV3e/PYXyd4M
X-Received: by 2002:adf:fb11:: with SMTP id c17mr10972952wrr.0.1570174461062;
        Fri, 04 Oct 2019 00:34:21 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxvQcgmyGS3G8q5MATkz1wmCFy63G+ea3phQ5+0hoNe8HjX26XKtAwtyxuWOXLFyvJErOCKQA==
X-Received: by 2002:adf:fb11:: with SMTP id c17mr10972907wrr.0.1570174460541;
        Fri, 04 Oct 2019 00:34:20 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id a7sm10244208wra.43.2019.10.04.00.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:34:20 -0700 (PDT)
Subject: Re: [RFC PATCH 12/13] mmap: Add XO support for KVM XO
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        luto@kernel.org, peterz@infradead.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-13-rick.p.edgecombe@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <a0ea3b34-2131-3fd5-3842-ae3f98edf8d8@redhat.com>
Date:   Fri, 4 Oct 2019 09:34:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003212400.31130-13-rick.p.edgecombe@intel.com>
Content-Language: en-US
X-MC-Unique: BQ2-Gv_PN8u_-B17CFKLag-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 23:23, Rick Edgecombe wrote:
> +
> +=09protection_map[4] =3D PAGE_EXECONLY;
> +=09protection_map[12] =3D PAGE_EXECONLY;

Can you add #defines for the bits in protection_map?  Also perhaps you
can replace the p_xo/p_xr/s_xo/s_xr checks with just with "if
(pgtable_kvmxo_enabled()".

Paolo

> +=09/* Prefer non-pkey XO capability if available, to save a pkey */
> +
> +=09if (flags & MAP_PRIVATE && (p_xo !=3D p_xr))
> +=09=09return 0;
> +
> +=09if (flags & MAP_SHARED && (s_xo !=3D s_xr))
> +=09=09return 0;
>
> +=09pkey =3D execute_only_pkey(current->mm);
> +=09if (pkey < 0)

