Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126FB1050CD
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 11:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKUKnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 05:43:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20521 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726957AbfKUKnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 05:43:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574332996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J3W8i0iOJEXyO2QTbJjCdfj028+OhlnLk7ZsSbSMbcA=;
        b=BIC61RulbmAXJgpVPcHhJxsIQzyCs2XW7hligC96rNMetDBo5Wx59tIsAGDLMLRrlVGhPn
        dXGG+qSqvpAi4SsKlRBEycfdVNgUfC0rl5r+a2HzwF13q5ZLMEF5uEQHePDX4axpihDUkw
        J+CbGBnXCvjEroNzLZWimcNvQO0+iVo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-t_jTQtnuNj-QTbxQsI5m9A-1; Thu, 21 Nov 2019 05:43:12 -0500
Received: by mail-wr1-f69.google.com with SMTP id h7so1889224wrb.2
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 02:43:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZIjxSWOpncWMeofwzEZL33olSoz/0WCOZe4bbP5QEmM=;
        b=VHug+oc6PYDCz/hkR/iR7GkBb2LjutesmhlmNUdpMQJuuTEmF7Kf+40wTxHtkT6Q8R
         yuMnbzSTeFY8HSRvBQJEL0WmHhs1xPIxpCjEEcxZTaM8v0JftnyYlKRI779XytzURbsP
         A9fhbVQZxFjKSnXfjcI4yutAuXQlj9pRCsyqeDbXYMyy0JJOqv0UQ6IZdUsNrlzYWaFl
         Y+2tiGwaAcxg9BGD0jfgB8JCL3KcL9Ti6lE1zkmmMzrsKU9EncyfWc7SKvxychlbORjR
         uJjOJshrZF/OolhOiOPRrctGxNl+FYmYT6BOybopRdBXu4PU9w2qsdv88YyJjRej5WID
         rScg==
X-Gm-Message-State: APjAAAXKGqc3mJAkhc+zpOg1+E8tCC8KfXADQOKcWcyzHMUkuhhgP0zS
        wgIOSoh+Rx9oSxhSKqVnwoNDz1WtUhGlbG4GuiWQB9gbblSq3RsK9KiLGKgG7SChvAmr+TTIcI7
        qYNqNdBAOhtRX
X-Received: by 2002:a1c:480a:: with SMTP id v10mr9232143wma.138.1574332991576;
        Thu, 21 Nov 2019 02:43:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqyCImg2J7Xc1OsIo0tikTSaBXY2RTIhLUoGtIR2rrRBxjuL0bnlR4mMAMX8ZoqqCoEEP3vZYg==
X-Received: by 2002:a1c:480a:: with SMTP id v10mr9232107wma.138.1574332991282;
        Thu, 21 Nov 2019 02:43:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:71a5:6e:f854:d744? ([2001:b07:6468:f312:71a5:6e:f854:d744])
        by smtp.gmail.com with ESMTPSA id u16sm2763530wrr.65.2019.11.21.02.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 02:43:10 -0800 (PST)
Subject: Re: [PATCH v7 4/9] mmu: spp: Add functions to create/destroy SPP
 bitmap block
To:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        sean.j.christopherson@intel.com
Cc:     yu.c.zhang@linux.intel.com, alazar@bitdefender.com,
        edwin.zhai@intel.com
References: <20191119084949.15471-1-weijiang.yang@intel.com>
 <20191119084949.15471-5-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ad27209-cc28-0503-da0e-bead63b28a83@redhat.com>
Date:   Thu, 21 Nov 2019 11:43:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191119084949.15471-5-weijiang.yang@intel.com>
Content-Language: en-US
X-MC-Unique: t_jTQtnuNj-QTbxQsI5m9A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/19 09:49, Yang Weijiang wrote:
> =20
> +/*
> + * all vcpus share the same SPPT, vcpu->arch.mmu->sppt_root points to sa=
me
> + * SPPT root page, so any vcpu will do.
> + */
> +static struct kvm_vcpu *kvm_spp_get_vcpu(struct kvm *kvm)
> +{
> +=09struct kvm_vcpu *vcpu =3D NULL;
> +=09int idx;

Is this true?  Perhaps you need one with
VALID_PAGE(vcpu->arch.mmu->sppt_root) for kvm_spp_set_permission?

Also, since vcpu->arch.mmu->sppt_root is the same for all vCPUs, perhaps
it should be kvm->arch.sppt_root instead?

If you can get rid of this function, it would be much better (but if you
cannot, kvm_get_vcpu(kvm, 0) should give the same result).

>=20
> +=09if (npages > SUBPAGE_MAX_BITMAP)
> +=09=09return -EFAULT;

This is not needed here, the restriction only applies to the ioctl.

Paolo

