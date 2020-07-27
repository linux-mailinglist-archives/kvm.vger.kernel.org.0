Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3102A22F686
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730682AbgG0RZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 13:25:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57066 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726617AbgG0RZb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 13:25:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595870729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ez7WeArkgioY0VlcfnY8q3j7rpYtHgMsNNYFl+uG8+0=;
        b=JpSsAkkEW29O/13PsiPsZlKUyvBtONG+MkssFDQ2pxwVpD5GECvKakqH2OLU/bTdZIwuKY
        zNSB2aqEMeIsROaf6/5KkCOThtiYKKNnPvxJUnm3i6tOZejYqDvWh4zObQrS6Qkmf84Noe
        o0ldx+Rl19wPBGyuLk4OBAHA2wQDvjg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-210-QkSiqZyOMJmJ0O3TwQ12sw-1; Mon, 27 Jul 2020 13:25:25 -0400
X-MC-Unique: QkSiqZyOMJmJ0O3TwQ12sw-1
Received: by mail-wm1-f72.google.com with SMTP id c124so6667445wme.0
        for <kvm@vger.kernel.org>; Mon, 27 Jul 2020 10:25:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ez7WeArkgioY0VlcfnY8q3j7rpYtHgMsNNYFl+uG8+0=;
        b=g2F0zzWT3GocgHK168F+U0OETkfRroQhV7xNEGDlWZ8p7Go8pTXRPmyrOy0GsOtBja
         kZhUBgG+wF2RsxS7LvamLn5FyCiM/GGlwgaOdeTFByYuKHoQ8MkVeQwKr/gdQnqql2Mn
         BMRSl7uOBpC1IBmPiS1OzMnaqrBsrjyjBLBL4kG+p/YTE5b5hhtDPv9+2WtsamHyZFK+
         ETcDNJ284XMYz/RNTaY5T1j992awy2FxBzZJmmJdgV/sH1Vjq64Wisl9nvVSFXqoJiWL
         NRsFEfdcoKPD6vR69OzR/uxc+g9KYAK8PZp9lrDrCa8w/90CsKYurQEAb4HXwNfHN964
         mdSQ==
X-Gm-Message-State: AOAM531O383oxGTV7f/9/9XJyC8hmWT/cFjBVg/utWQwNm4awynJSqX5
        RY2Hm7v6LP+tkdUhbDW8ltHuzT+4KdIFri7hxiTuYwPAfvCivzyE5P7amuEXKMWbZNuu44utSpC
        E5zOjb2SHb459
X-Received: by 2002:a1c:80d0:: with SMTP id b199mr332455wmd.28.1595870722981;
        Mon, 27 Jul 2020 10:25:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoV6Ud8vEStX9/KvnrqXEZPu6H8nd0FdSRYXzSjf3jHkiNLbDvOJ4PNJmEyHTo5QR6LuXFIQ==
X-Received: by 2002:a1c:80d0:: with SMTP id b199mr332449wmd.28.1595870722789;
        Mon, 27 Jul 2020 10:25:22 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:80b0:f446:bb61:1dbb? ([2001:b07:6468:f312:80b0:f446:bb61:1dbb])
        by smtp.gmail.com with ESMTPSA id v29sm14547080wrv.51.2020.07.27.10.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 10:25:22 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] arm64: Compile with -mno-outline-atomics
 for GCC >= 10
To:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20200717164727.75580-1-alexandru.elisei@arm.com>
 <20200718091145.zheu46pfjwsntr3a@kamzik.brq.redhat.com>
 <202d475d-95df-2350-a8e9-9264144993ac@arm.com>
 <1bf2eab6-c6df-8b4c-b365-7216e7b9a9d7@arm.com>
 <20200727123031.7v52lu23mmhailar@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b47a7fc1-fca6-4401-ab47-4167d37eab8b@redhat.com>
Date:   Mon, 27 Jul 2020 19:25:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200727123031.7v52lu23mmhailar@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/07/20 14:30, Andrew Jones wrote:
>>> Looks much better than my version. Do you want me to spin a v2 or do you want to
>>> send it as a separate patch? If that's the case, I tested the same way I did my
>>> patch (gcc 10.1.0 and 5.4.0 for cross-compiling, 9.3.0 native):
>>>
>>> Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Gentle ping regarding this.
>>
> Hi Alexandru,
> 
> I was on vacation all last week and have been digging myself out of email
> today. I'll send this as a proper patch with your T-b later today or
> tomorrow.

Same here; will wait for Andrew's patch.

Paolo

