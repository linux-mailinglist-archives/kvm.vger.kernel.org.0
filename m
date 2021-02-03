Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A8230DFE4
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 17:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhBCQkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 11:40:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhBCQkO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 11:40:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612370328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEevBfuF/2D3zvQy2S5Qrf1G+I9ILJ9Q0g1aU3+YVGs=;
        b=XUCoqYtcFe0GkTBK2yMU5Qknj375wMxr/kIOZOllchnHAZyhLtN8Fr2vU1XetFWn/+6pPk
        KBqIGiAEv3VzY1JDRkVU+3pniVmiCn+ss2z1UCFPj+CNW+lvkxT7LUrufJxLSCLOLo5BKu
        YlVwfBijuZEOk66WFfaMrSql5J7vlJ4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-Qqz_ZGqkNMiVaQoYaeedug-1; Wed, 03 Feb 2021 11:38:47 -0500
X-MC-Unique: Qqz_ZGqkNMiVaQoYaeedug-1
Received: by mail-ed1-f72.google.com with SMTP id bo11so157028edb.0
        for <kvm@vger.kernel.org>; Wed, 03 Feb 2021 08:38:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KEevBfuF/2D3zvQy2S5Qrf1G+I9ILJ9Q0g1aU3+YVGs=;
        b=Mi8psTni/LnvbyrEfyejEO9VrlP8gE6CgCZ8bo/GMKD6DEesHGp3Ji5xA6B2Btg0UP
         V8huErCvUurdouqzfrWiseX7D3oiRPo6gPVp5nCunde4cRp8y1mOblpixcqM8zycxNAQ
         ugVEpN8Wt4uQVtbtfBgBa2xVc+jVKICxlOz2CJ3/XNMwU63Bp0jtD6aKEJJwOvJwgtaD
         4g6Trv7XZSIFWPhXFbX5KF/ZCyJINRu4b1R5z6MOmonilWYRojYAFYJ7JDQrDlnfvdXE
         n9EdKbb3oDm3VO+8sh0vMAMp/gWnTqdOsCHpt+OvRYD27eVs1aQWoTDSVSKK6zAcapw+
         ecww==
X-Gm-Message-State: AOAM531VD2zERP/3LiQHGI37PoQ2O2o24PV8D1dT36+2Y4tssdmxzcK7
        WVbVhylNKK9CV6rQvDgKX1+05rvw+oFt3dP9ZPBZBrj9v4W/OGKz7uW88312ej9hS7iVyVLHp3q
        Cnt4wsJFqyEa4
X-Received: by 2002:a17:906:780b:: with SMTP id u11mr4021198ejm.492.1612370325821;
        Wed, 03 Feb 2021 08:38:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwSv3VVkPvHSZ6/+ev1XoXKlB76xhYcZ5l0qb4ZlcILqMaKYteB+ttYzDUJLG7BTC+rhV3LsA==
X-Received: by 2002:a17:906:780b:: with SMTP id u11mr4021170ejm.492.1612370325621;
        Wed, 03 Feb 2021 08:38:45 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h3sm1120926edw.18.2021.02.03.08.38.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 08:38:44 -0800 (PST)
Subject: Re: [PATCH v6 18/19] KVM: x86: declare Xen HVM shared info capability
 and add test case
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com, hch@infradead.org
References: <20210203150114.920335-1-dwmw2@infradead.org>
 <20210203150114.920335-19-dwmw2@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <190ec822-6010-5060-a6e8-9a49696abd0c@redhat.com>
Date:   Wed, 3 Feb 2021 17:38:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210203150114.920335-19-dwmw2@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 16:01, David Woodhouse wrote:
> 
> +struct vcpu_runstate_info {
> +    uint32_t state;
> +    uint64_t state_entry_time;
> +    uint64_t time[4];
> +};
> +
> +static void guest_code(void)
> +{
> +	struct vcpu_runstate_info *rs = (void *)RUNSTATE_ADDR;
> +
> +	/* Scribble on the runstate, just to make sure that... */
> +	rs->state = 0x5a;
> +
> +	GUEST_SYNC(1);
> +
> +	/* ... it is being set to RUNSTATE_running */
> +	GUEST_ASSERT(rs->state == 0);
> +	GUEST_DONE();
> +}

Leftovers?

Paolo

