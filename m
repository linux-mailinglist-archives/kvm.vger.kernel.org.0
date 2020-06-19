Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59C6F2011B5
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394077AbgFSPnn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:43:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58962 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2394065AbgFSPnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 11:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592581410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJ4olDP4sE92e0G3XhQT7E9mJ/AvOujEs+OICxyS890=;
        b=hAn1461PW1iP6vlcEItLPBnI42Q+yqzlQJRRefWAM4sBBAJyky0UhdwDyfEXLxAPF1gult
        yTJVQlSLiC5GKf4EpLJUTl1iBiBZpVKEo9Rj4D1VppqQz0wmyYit1/AAYu34wA899flaXN
        CoSaU1gBTbNBj9VHaBwLvLj3PFCfg6k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-ux74PetVNR6FFkG-TQ0T6Q-1; Fri, 19 Jun 2020 11:43:28 -0400
X-MC-Unique: ux74PetVNR6FFkG-TQ0T6Q-1
Received: by mail-wr1-f70.google.com with SMTP id e1so4452137wrm.3
        for <kvm@vger.kernel.org>; Fri, 19 Jun 2020 08:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BJ4olDP4sE92e0G3XhQT7E9mJ/AvOujEs+OICxyS890=;
        b=IIJ4IOGmr6LW2MCefSQBGxWIcGSNRGQZDBIfz/vMSkpqXHcfgY/ndtB6ca6P+oiYTJ
         houdIsuhN0JG2Ie0mxarc86UogUvkaIKXROQRF3rKTY9eych/zpAVBnkrC9d3FAHGSJp
         vdezSiEAuJ2Ip42N021/28cA5fcrLj9N66hjY3z6VrfJVlQk5maxuvtt4gEImYmK98W8
         IcULMTjcPEnyWCGII7Ns6FMLfKNRAIVaeWXihMgSXB6QLUIgiq3PCDtnW8ueFpu0k1er
         XdNUbolP0RNmvcPl4ivMXoS4GpztnMCnQcB9w3DgPqawYAMnb381vlfTLIxtTwbOkkws
         ZHvw==
X-Gm-Message-State: AOAM530mgtBSIVMv7KvTgWwAmnv7F6jKthTVidST8EZHQvbQd3sdLsx1
        5Whtv7spXzTCAQGgA/TK9+EsHu2CBgq5zIns+nQlaoHGOlEsN3wChXgYtV7QhGvw0d0qZTUNSl1
        qu5dfX6/4tRRz
X-Received: by 2002:a1c:ab04:: with SMTP id u4mr4641082wme.52.1592581407893;
        Fri, 19 Jun 2020 08:43:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzM2p8s4uLxagQNK//PxpJ+oT8+9b3lN2UK1YhhNUn9fFNMbEk3eFggdKAd4PlTflL32CmW3Q==
X-Received: by 2002:a1c:ab04:: with SMTP id u4mr4641071wme.52.1592581407700;
        Fri, 19 Jun 2020 08:43:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e1d2:138e:4eff:42cb? ([2001:b07:6468:f312:e1d2:138e:4eff:42cb])
        by smtp.gmail.com with ESMTPSA id d63sm7719649wmc.22.2020.06.19.08.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jun 2020 08:43:27 -0700 (PDT)
Subject: Re: [PATCH v2 00/11] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Mohammed Gamal <mgamal@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com
References: <20200619153925.79106-1-mgamal@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <87312ebb-e842-3b21-e216-916d54557319@redhat.com>
Date:   Fri, 19 Jun 2020 17:43:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200619153925.79106-1-mgamal@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/20 17:39, Mohammed Gamal wrote:
> The last 3 patches (i.e. SVM bits and patch 11) are not intended for
> immediate inclusion and probably need more discussion.
> We've been noticing some unexpected behavior in handling NPF vmexits
> on AMD CPUs (see individual patches for details), and thus we are
> proposing a workaround (see last patch) that adds a capability that
> userspace can use to decide who to deal with hosts that might have
> issues supprting guest MAXPHYADDR < host MAXPHYADDR.

I think patch 11 can be committed (more or less).  You would actually
move it to the beginning of the series and have
"allow_smaller_maxphyaddr = !enable_ept;" for VMX.  It is then changed
to "allow_smaller_maxphyaddr = true;" in "KVM: VMX: Add guest physical
address check in EPT violation and misconfig".

In fact, it would be a no-brainer to commit patch 11 in that form, so
feel free to submit it separately.

Thanks,

Paolo

