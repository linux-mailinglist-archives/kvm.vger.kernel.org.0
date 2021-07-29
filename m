Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C62D23DA030
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 11:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235469AbhG2JTT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 05:19:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235141AbhG2JTQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 05:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627550353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TQtX4nl+bgLotIZVMoQcJea91i0zd8bRKZAXW/3xbo0=;
        b=TbYGr8/9wkyxhgueCGNelFV0drXi/AXkry7bywBIRm3DXeVarrfT3xW9thaDs/U4InsIy1
        fWoBnBlFHeeyWZmYJHj4/OPEWwDZEVGX23nqPZxvM/ojEE8FwHhXcgUwiTvjf2Olqr9oKW
        cEtJhcF3QnBK0BjU9g2IwYt6s9NxCHI=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-87-Wo5vxzGQP9ywpPwfFqeL6A-1; Thu, 29 Jul 2021 05:19:12 -0400
X-MC-Unique: Wo5vxzGQP9ywpPwfFqeL6A-1
Received: by mail-ej1-f70.google.com with SMTP id q19-20020a170906b293b029058a1e75c819so1751772ejz.16
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 02:19:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TQtX4nl+bgLotIZVMoQcJea91i0zd8bRKZAXW/3xbo0=;
        b=fzWjuODGTN70I73J1rkp+7xoc1khRtAcRQRvLJrdLqFkR13z7OtFcatBntwdtwyIzt
         +pc2USUSTvNEerOVTGowsuSWsqv1DFQkyExr33OmtaxUpM4n+gkBg7YhXOdJEkRafd5T
         pyQKYUSzpNAgivDkCFZaE8G2PXgPvEB6zx+cjC58lz7omm+2WntctW9vW3yApW1d11Wz
         c2Uvpn6DHehcMmOs51zdyJ+3nezbaw4QmQNvp2ol9Q61UXXuD4pRnEfX+Rl+zBB7pckZ
         XD1Cilf3IJxVyIwK23JQWMYD9lwbwpi0Ug/sqNrU0Z2HB7cXClVcDTsXCwQDSwxi8E06
         iWzQ==
X-Gm-Message-State: AOAM533LDW98GfRsvqLTj5dNR1BCc0qhImXH4U3xJJOC24PoRVayHZ9f
        6NY//O9erDUoPjicwJueIpFwQRp9Q1/Ok7pA2jMpO9Gqer9+odrbyMXlvqYFRNG+kvW8ZWlT6L+
        QX+bV2jj4PL4zFzEll4m9ItNEwBlZ+FUgbJ2ZzpPmM92+uW7lVgwBaXkcOcc0Sw1s
X-Received: by 2002:a50:8dcc:: with SMTP id s12mr4984972edh.105.1627550350755;
        Thu, 29 Jul 2021 02:19:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwYgU4uMoa/dLjL05zY7u1Ivsq7P/TEzk6ReB1xBOBalnjrk3TIolh+YRYZX5JR7C2zX53yxA==
X-Received: by 2002:a50:8dcc:: with SMTP id s12mr4984948edh.105.1627550350553;
        Thu, 29 Jul 2021 02:19:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id d8sm946492edj.19.2021.07.29.02.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 02:19:09 -0700 (PDT)
Subject: Re: A question of TDP unloading.
To:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Ben Gardon <bgardon@google.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20210727161957.lxevvmy37azm2h7z@linux.intel.com>
 <YQBLZ/RrBFxE4G4w@google.com>
 <20210728065605.e4ql2hzrj5fkngux@linux.intel.com>
 <20210728072514.GA375@yzhao56-desk.sh.intel.com>
 <CANgfPd_Rt3udm8mUHzX=MaXPOafkXhUt++7ACNsG1PnPiLswnw@mail.gmail.com>
 <20210728172241.aizlvj2alvxfvd43@linux.intel.com>
 <CANgfPd_o+HC80aqTQn7CA3o4rN2AFPDUp_Jxj9CQ6Rie9+yAug@mail.gmail.com>
 <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dd09360e-436e-4e66-faad-656c8aa9cee2@redhat.com>
Date:   Thu, 29 Jul 2021 11:19:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729030056.uk644q3eeoux2qfa@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/07/21 05:00, Yu Zhang wrote:
>> I have a few questions about these unnecessary tear-downs during boot:
>> 1. How many teardowns did you observe, and how many different roles
>> did they represent? Just thrashing between two roles, or 12 different
>> roles?
> I saw 106 reloadings of the root TDP. Among them, 14 are caused by memslot
> changes. Remaining ones are caused by the context reset from CR0/CR4/EFER
> changes(85 for CR0 changes).

Possibly because CR0/CR4/EFER are changed multiple times on SMM entry 
(to go from real mode to protected mode to 32-bit to 64-bit)?  But most 
of those page tables should be very very small; they probably have only 
one page per level.  The SMM page tables are very small too, the only 
one that is really expensive to rebuild is the main non-SMM EPT.

Paolo

