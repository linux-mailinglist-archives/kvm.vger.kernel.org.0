Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6442077B
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 10:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhJDImn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 04:42:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30247 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229685AbhJDImn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 04:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633336854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++xf85KrwjKjUR0N++5TlHyfSBlnuiKqimGu6zW+36M=;
        b=BIFX/Xp8W5vCuMPd7cPWFs78RVgTUCVjP0VTo+0sz8hjJyajxU70a2Dnu1UivaZNCmcNdM
        757OvBPCFQIYIzDgTfJqVfMD5rgWC5uyzLEV6qrJUk9qG+7zV7xN/ErOcwazwodh0Y2IQj
        m8xrvBvSpU6ZwgSarXokvndSG8tUkt8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-JAhELUt4O1abW9FlZvtfuQ-1; Mon, 04 Oct 2021 04:40:52 -0400
X-MC-Unique: JAhELUt4O1abW9FlZvtfuQ-1
Received: by mail-ed1-f71.google.com with SMTP id w8-20020a50c448000000b003dae8d38037so3387179edf.8
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 01:40:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=++xf85KrwjKjUR0N++5TlHyfSBlnuiKqimGu6zW+36M=;
        b=3dPnECkgGy2dSCk+38w7m1hCtOGVoUf5NeSGBcFHWTnuEBmIHsQn2LZIQUeBivOpvs
         42VpW+PjGWuEn53EQgY37RbfH+DnpZNQrXOTjz6osmp2WW0bXADrjRPfpcCqP6XalYy7
         rM5eyoAt6LfKy56xwmagCkuf2vFIA0cKhCyjbgTKfgVilEtnGwFF71cVd/Yu1Zc1d2z4
         mzwEoYlUsyKJBF6+51jTZo4cuLgic1L26zQPsEa14tau1gbJLLajEDZftloAIp7xhCE3
         xdlaVg9Xb1OYgCEgZZmnGbvBl+OHCHwyJfawdEHUUDQZv7/HS26TnvY//cq0g+pnU1Q+
         LT/g==
X-Gm-Message-State: AOAM532VOxarbJX4vVdL822S2zim8KRDlcxxePp8eLJgmXbeAlO45blV
        8Nb0xhyEpIz2ZCDwVDbFYJETQBRxxneh5qXBcJgAZZ2ZTzx9QVlZ7edu51RlrhQ1H39uNfHJKsV
        RIqPNYNvDRhtU
X-Received: by 2002:a17:906:bcf7:: with SMTP id op23mr16092833ejb.317.1633336851490;
        Mon, 04 Oct 2021 01:40:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzcakdHkBGbuLanS3x3wbeKZDEtGC7oRl9PdPTJXqNEgmgTiWU4R0A0+dfATKe3rGIuRn6dnQ==
X-Received: by 2002:a17:906:bcf7:: with SMTP id op23mr16092816ejb.317.1633336851258;
        Mon, 04 Oct 2021 01:40:51 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j16sm6957067edw.23.2021.10.04.01.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 01:40:50 -0700 (PDT)
Message-ID: <86d3981b-2195-7c03-9917-520761aaeaa5@redhat.com>
Date:   Mon, 4 Oct 2021 10:40:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v20 00/17] KVM RISC-V Support
Content-Language: en-US
To:     Palmer Dabbelt <palmerdabbelt@google.com>, anup@brainfault.org
Cc:     Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
        graf@amazon.com, Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <Anup.Patel@wdc.com>,
        philipp.tomsich@vrull.eu
References: <mhng-b5a035ae-a545-4c81-a8d9-301c6f7e6982@palmerdabbelt-glaptop>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <mhng-b5a035ae-a545-4c81-a8d9-301c6f7e6982@palmerdabbelt-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/10/21 18:18, Palmer Dabbelt wrote:
> 
> Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
> 
> IIUC the plan here involved a shared tag at some point, with most of 
> this going through Paolo's tree.  If you still want me to merge 
> something then I'm happy to do so, just make it clear as I've mostly 
> lost track of things.

I'll prepare a shared tag with the first two patches as soon as I finish 
reviewing the rest.

Paolo

