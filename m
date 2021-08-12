Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 683233EA840
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 18:08:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhHLQIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 12:08:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:57353 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229531AbhHLQIn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Aug 2021 12:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628784497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NC2grUc+9VigyJodqV99VTSbnwgVEyRzZ6GRs3RHECQ=;
        b=Nm8UCcDvpHc1R7T2BV6kU3Y9YZWomNxST5lZR72g/NtQR3OHxgXJK4EVJDQWNGxbkBqQAh
        TxirhrC8mzLt20Z4NBGQRKqkpM3wecISZvSUVyKZWHH1pzw9BdudBJBDNQ23C9XBChWZhQ
        PI0HdH52asksmlWb/BCBLUOv//KxI1U=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-8-mW03LJNYG7emjn5fxo9w-1; Thu, 12 Aug 2021 12:08:16 -0400
X-MC-Unique: 8-mW03LJNYG7emjn5fxo9w-1
Received: by mail-ed1-f69.google.com with SMTP id y39-20020a50bb2a0000b02903bc05daccbaso3276431ede.5
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 09:08:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NC2grUc+9VigyJodqV99VTSbnwgVEyRzZ6GRs3RHECQ=;
        b=YXxaGq1qpvqPZkOSrYRYdU3mef1h32TXZSlX/O7HowhA94b4Cd8Js+mc493eojYT1V
         XqNcxBskRWrFA0ZYetfOkGQQTz+Fkqz2mxHe94IGLC9Huy1ZdqQG9ZWVObNyUWYuPOu2
         0KSSRKkOUp6Joi04zHAwfbovWWL1SAk85+pNlWRH76ePtp443Kzv+Wi53bKS1KmvlGSG
         S/xFnpnHU7/OD3wPQUqEfdGQYLrYz5Beeg7JpgREd3/Ue0HPZ9eX8m/Sjc6uKYmcavEu
         BTD7Eg5Ot/1sj/g0YNpSF1aqWKHEnQ2EDh/S9cdvqBDolymSU5hhOZY5ipf/fDLvowJS
         yPyA==
X-Gm-Message-State: AOAM530Nqhia1VCuwgri3mABJ5t1jqPqYLc6cCH2kOBpPA/Uc2XzGsyg
        fFR+0dGiR9scj16yIROuFSJCpKiAFxDwgih8RSB/5ORu1gituxnyiP1dAH+0bHxNIu15nZVSTQS
        mGbpsnuq8YDO1
X-Received: by 2002:a17:906:268b:: with SMTP id t11mr4302638ejc.397.1628784494934;
        Thu, 12 Aug 2021 09:08:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxjz81j497np4AqnhzyQa+PN7vTdq0qY+6XrMtspj32CP1R8ZfSB503IdNFzh2rJLzAYacTDA==
X-Received: by 2002:a17:906:268b:: with SMTP id t11mr4302619ejc.397.1628784494727;
        Thu, 12 Aug 2021 09:08:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h8sm983608ejj.22.2021.08.12.09.08.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 09:08:12 -0700 (PDT)
Subject: Re: [PATCH v1] KVM: stats: Add VM stat for the cumulative number of
 dirtied pages
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Peter Feiner <pfeiner@google.com>
References: <20210811233744.1450962-1-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6296f7ac-bf99-2198-5a02-9d1ad721cbd3@redhat.com>
Date:   Thu, 12 Aug 2021 18:08:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210811233744.1450962-1-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/08/21 01:37, Jing Zhang wrote:
> A per VM stat dirty_pages is added to record the number of dirtied pages
> in the life cycle of a VM.
> The growth rate of this stat is a good indicator during the process of
> live migrations. The exact number of dirty pages at the moment doesn't
> matter. That's why we define dirty_pages as a cumulative counter instead
> of an instantaneous one.

Why not make it a per-CPU stat?  mark_page_dirty_in_slot can use 
kvm_get_running_vcpu() and skip the logging in the rare case it's NULL.

Paolo

