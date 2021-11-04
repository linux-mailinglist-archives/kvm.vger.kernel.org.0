Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD013445BFB
	for <lists+kvm@lfdr.de>; Thu,  4 Nov 2021 23:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhKDWIA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 18:08:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36752 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231849AbhKDWH6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Nov 2021 18:07:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636063518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=55IgmPgmgSuFU9TD9sDvt/2ASWtxXb/fPvF+Rr/pBEI=;
        b=KXH2FudUV+PVpqDrYGAryNk/s5nhJ5Fkc2IG1Fr1SJpmBSaB7QzArU59xncJV1ya0d3Vbr
        fOFE9PJHlCOp+KKXozJXOevNXlCXCaUWEfi7tllQyO9qEa7s0uzWcFLELFTs7+ZmJqJJk3
        MzeTNftH56dRKhJQ/DxBP2TbxlpiaUw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-176Jh2ZyNC-pFSM3iTmqVQ-1; Thu, 04 Nov 2021 18:05:17 -0400
X-MC-Unique: 176Jh2ZyNC-pFSM3iTmqVQ-1
Received: by mail-wm1-f69.google.com with SMTP id v18-20020a7bcb52000000b00322fea1d5b7so2863081wmj.9
        for <kvm@vger.kernel.org>; Thu, 04 Nov 2021 15:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=55IgmPgmgSuFU9TD9sDvt/2ASWtxXb/fPvF+Rr/pBEI=;
        b=SoILXf/V0NVcpemuDSJWFHK4z0vcFwhBeqw/GCUaVdXu2Uw04pzIZu0ueJkZOL6xaU
         EoeQIk2gPRh/3eaIN5dDOvwkbxFi6cWIPB1apMIZkITBeu/xKsY1pSVdEhhtzm1+GVkT
         Qcc8SDRKFHqFxVQH+S7bU5kTDcthWmvz8MtHpMdjzhNOFR14EFJKIcqSUN4S4/XHHyfE
         8QR0NBeL9CuwFfvYGzo2XyNRiLLhWlpvipFFI9Stohz4Luq3DJDxNK81fEJx1NJhbFxn
         w6dJBkrFAMVEwCzdq4/EAbnkOtoGwKLCZWD9EfWm1M8gQ3IF028INCKcb3WyoYBzlBEH
         +FgQ==
X-Gm-Message-State: AOAM530rTSccxObV6Mm6WXb34L3kxGaIgq0mcyTQG3uB/7Mq08R0ywey
        L+0SxGzznlPWH/Pjl2NYj0cm+eeglbEvdFTHTIFuan2ribbhrRCJX2OEpANjw8wBQ7Y35WwGniY
        wkoXo/8/oHZ09
X-Received: by 2002:a7b:c316:: with SMTP id k22mr27241664wmj.22.1636063516522;
        Thu, 04 Nov 2021 15:05:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjuyOzFEoyPllk1OzGlmTypUNL8HrTM0i7sNCF1fqIwt5RxcZxT6UmP+XE0SaD8CiW4+dEaQ==
X-Received: by 2002:a7b:c316:: with SMTP id k22mr27241636wmj.22.1636063516364;
        Thu, 04 Nov 2021 15:05:16 -0700 (PDT)
Received: from [192.168.1.36] (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id c17sm6507637wmk.23.2021.11.04.15.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 15:05:15 -0700 (PDT)
Message-ID: <6f8b30c5-d93d-882d-cf1a-502592e4bcf8@redhat.com>
Date:   Thu, 4 Nov 2021 23:05:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PULL 07/20] migration/dirtyrate: implement dirty-ring dirtyrate
 calculation
Content-Language: en-US
To:     Juan Quintela <quintela@redhat.com>, qemu-devel@nongnu.org,
        Laurent Vivier <laurent@vivier.eu>
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?B?SHltYW4gSHVhbmcow6nCu+KAnsOl4oC54oChKQ==?= 
        <huangy81@chinatelecom.cn>
References: <20211101220912.10039-1-quintela@redhat.com>
 <20211101220912.10039-8-quintela@redhat.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>
In-Reply-To: <20211101220912.10039-8-quintela@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Juan,

On 11/1/21 23:08, Juan Quintela wrote:
> From: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>
> 
> use dirty ring feature to implement dirtyrate calculation.
> 
> introduce mode option in qmp calc_dirty_rate to specify what
> method should be used when calculating dirtyrate, either
> page-sampling or dirty-ring should be passed.
> 
> introduce "dirty_ring:-r" option in hmp calc_dirty_rate to
> indicate dirty ring method should be used for calculation.
> 
> Signed-off-by: Hyman Huang(é»„å‹‡) <huangy81@chinatelecom.cn>

Just noticing in the git history some commits from your
pull request have the author name (from + S-o-b) mojibaked.

> Message-Id: <7db445109bd18125ce8ec86816d14f6ab5de6a7d.1624040308.git.huangy81@chinatelecom.cn>
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Reviewed-by: Juan Quintela <quintela@redhat.com>
> Signed-off-by: Juan Quintela <quintela@redhat.com>
> ---
>  qapi/migration.json    |  16 +++-
>  migration/dirtyrate.c  | 208 +++++++++++++++++++++++++++++++++++++++--
>  hmp-commands.hx        |   7 +-
>  migration/trace-events |   2 +
>  4 files changed, 218 insertions(+), 15 deletions(-)

