Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA91D8963
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 09:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387436AbfJPH2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 03:28:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27877 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726747AbfJPH2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 03:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571210899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=orARpy9VRasxbGIspeFw1If4V+0a0FfvdhS9bjyo93c=;
        b=fppGVp/0W0FXSqnhPNFe25Zruf/UvaiCCP6746zclDk/CcwKrR1Q0PccjxjSw119stdbUx
        tYp4RrBuqV8i86QFBFUqdCjtBdQH3pxWQspLC8SI6mGB9/PcJTY7Pc7MdjkueZJDKP/LzQ
        saRtEL3Yv6Jjva3YMkXSEH3A9mXBlmc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-rtchB41OOr6IJBp5kC0TOQ-1; Wed, 16 Oct 2019 03:28:17 -0400
Received: by mail-wm1-f71.google.com with SMTP id p6so587832wmc.3
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 00:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7v786RFqnJJe2y+7zEeSjJrSBT0qBrvwn+uIieIG8Ms=;
        b=k0UyHulWq7Nk2hO9dHgf4au5chL/s0vLpK5XSpqI91sn7it4Ifx3QzWgXgyScJMjNe
         JqL9m5jdIg4p2/lsRHwipy9GWyEoiitE1De8rn5QcnTaprqzHywGjJX4HWKv/AVw0qOx
         lQPrrcMTDEgurLvcnX+ltZfyl70ARu9j7W3kgQ0LZCmlcL/L11OP88V7G32BEeLfFKHg
         dAaFbcWU1w6Wu1olHy8Gcpix4otAfzCeR6JnSQLR9DwmePGuZmrRqmhPjp7H5xY7YNF+
         W1uP2v4756W+a704oxjXNJNPytsL2ac8FziW5G42Ir4/YAzgqcAtoacfHrGOy8/n669d
         E+rg==
X-Gm-Message-State: APjAAAWpCKj3t+YvQ6CysdWerkjjgg7UwwP9dEP87IBUEEU4R+0YfxHt
        leZ5O+TLtNCAZ+JqeCyBMrIDhhCBY60NISp20Uk2MA2ONsIMOL1woyPsos++HW4DLjvQ/fK899C
        8MuyBXLyGKYRP
X-Received: by 2002:a5d:490e:: with SMTP id x14mr1424541wrq.340.1571210896146;
        Wed, 16 Oct 2019 00:28:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzrga6sd4ikh+rWvg3KMNJWSZwdB+eC+kvA/j2r1CvW49OSSS+gZpwKzGXfYQFOXOcRgaXiSw==
X-Received: by 2002:a5d:490e:: with SMTP id x14mr1424482wrq.340.1571210895296;
        Wed, 16 Oct 2019 00:28:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ddc7:c53c:581a:7f3e? ([2001:b07:6468:f312:ddc7:c53c:581a:7f3e])
        by smtp.gmail.com with ESMTPSA id x16sm17648210wrl.32.2019.10.16.00.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 00:28:14 -0700 (PDT)
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
To:     Derek Yerger <derek@djy.llc>, kvm@vger.kernel.org
References: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ae30e8c8-5893-5249-4c40-0278bb93a0a6@redhat.com>
Date:   Wed, 16 Oct 2019 09:28:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1e525b08-6204-3238-5d56-513f82f1d7fb@djy.llc>
Content-Language: en-US
X-MC-Unique: rtchB41OOr6IJBp5kC0TOQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 06:49, Derek Yerger wrote:
> In at least Linux 5.2.7 via Fedora, up to 5.2.18, guest OS applications
> repeatedly crash with segfaults. The problem does not occur on 5.1.16.
>=20
> System is running Fedora 29 with kernel 5.2.18. Guest OS is Windows 10
> with an AMD Radeon 540 GPU passthrough. When on 5.2.7 or 5.2.18,
> specific windows applications frequently and repeatedly crash, throwing
> exceptions in random libraries. Going back to 5.1.16, the issue does not
> occur.
>=20
> The host system is unaffected by the regression.
>=20
> Keywords: kvm mmu pci passthrough vfio vfio-pci amdgpu
>=20
> Possibly related: Unmerged [PATCH] KVM: x86/MMU: Zap all when removing
> memslot if VM has assigned device
>=20
> Workaround: Use 5.1.16 kernel.

This should have been fixed in 5.2.16 through the following patches:

- "[x86] Revert "KVM: x86/mmu: Zap only the relevant pages when removing
a memslot" (5.2.11)

- "KVM: x86/mmu: Reintroduce fast invalidate/zap for flushing memslot"
(5.2.16).

Paolo

