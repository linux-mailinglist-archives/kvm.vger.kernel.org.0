Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93819CB4F4
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 09:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729970AbfJDH1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 03:27:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23847 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728140AbfJDH1P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Oct 2019 03:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570174033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=XUCVhLyFU0egbeCCPyi0gdOMvXkRkhtQ2UQBx6VdaxY=;
        b=IsIt9NAQW1emN3o31/e9G7Q0L6ElHcLkNQNEF43Buh4YusBLfeIinADVCsYky2Ck6vWrNR
        ZTcG2DeNLY5dMiFZpeTJ5p0hdOG/2mi9e8Yj3dG+zNlMFhWvJawz02D2ZXnd0y5BlgcD++
        oCHWc6SQ5shLa4NDXwhJlyoqnE69YgU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-NASgcO42MiizJ9YAxGiNPQ-1; Fri, 04 Oct 2019 03:27:12 -0400
Received: by mail-wr1-f72.google.com with SMTP id w8so2313491wrm.3
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 00:27:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aEdY8z5AWfJTa7GTLm63bwyTFqdMFQ7x24M2Gp/SY3g=;
        b=TVdNxzB/LooUzb+RsLONiZmE78TZW+R6GvHB+CSh73A6a8ZGkkqD2Cr39ALO83VaF3
         FB/DIlLqGad4UjsWIEA14NrjU6QjZtMzK7xJC+uNAwBE8YBlDgALPK/MqEuOh0pRD+fG
         TffWuehDpKrQeBnb7PvZyi7222IPqt4/eBxK+Wf615a50SEO8FE7ae835JRXjNuNNiDW
         EBX+pYNzQTjRWExcceNl0WZNYTMGy2pasJUAPzvdK1mmTA8pKlRdgBLhr4JJ7dmIqHss
         yRMA/qEYbSaJkJP5n3XESc5R51lySCFIb1ZWFxrK5mDZHHG2CW7y/b1mFjrsAmOZ7HnE
         vDrw==
X-Gm-Message-State: APjAAAVrRFakX0bep2lHfLcH1FuDymHNmUkFQm4vgWOm91xUfgEpFpCO
        AUfw/4axhCFLXeHhfIGyu44oij1z2pC9b4mKMeVnpgCjMPbR6q5780bkMQ5yo3kufu5BmzxsWgG
        wS5MTLUZg3MtQ
X-Received: by 2002:adf:ef4a:: with SMTP id c10mr1474582wrp.10.1570174030808;
        Fri, 04 Oct 2019 00:27:10 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwVRPZN9h/0C4acuqjoYLiCq8cberKuvezxJ5ZluiUcxk7RleMGP3eYODMaMTDsSPJdw/GkUg==
X-Received: by 2002:adf:ef4a:: with SMTP id c10mr1474556wrp.10.1570174030564;
        Fri, 04 Oct 2019 00:27:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e56d:fbdf:8b79:c79c? ([2001:b07:6468:f312:e56d:fbdf:8b79:c79c])
        by smtp.gmail.com with ESMTPSA id m16sm3817660wml.11.2019.10.04.00.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2019 00:27:09 -0700 (PDT)
Subject: Re: [RFC PATCH 03/13] kvm: Add XO memslot type
To:     Rick Edgecombe <rick.p.edgecombe@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        luto@kernel.org, peterz@infradead.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, keescook@chromium.org
Cc:     kristen@linux.intel.com, deneen.t.dock@intel.com,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20191003212400.31130-1-rick.p.edgecombe@intel.com>
 <20191003212400.31130-4-rick.p.edgecombe@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <5201724e-bded-1af1-7f46-0f3e1763c797@redhat.com>
Date:   Fri, 4 Oct 2019 09:27:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003212400.31130-4-rick.p.edgecombe@intel.com>
Content-Language: en-US
X-MC-Unique: NASgcO42MiizJ9YAxGiNPQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/10/19 23:23, Rick Edgecombe wrote:
> Add XO memslot type to create execute-only guest physical memory based on
> the RO memslot. Like the RO memslot, disallow changing the memslot type
> to/from XO.
>=20
> In the EPT case ACC_USER_MASK represents the readable bit, so add the
> ability for set_spte() to unset this.
>=20
> This is based in part on a patch by Yu Zhang.
>=20
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Instead of this, why not check the exit qualification gpa and, if it has
the XO bit set, mask away both the XO bit and the R bit?  It can be done
unconditionally for all memslots.  This should require no change to
userspace.

Paolo

