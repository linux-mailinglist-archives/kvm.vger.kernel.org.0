Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B431D4BBCF2
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 17:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbiBRQD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 11:03:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233766AbiBRQD1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 11:03:27 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B45148E47
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:03:08 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m126-20020a1ca384000000b0037bb8e379feso8938486wme.5
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 08:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hdEBdEgMAGoMMquMfCuquQI2IgK+7lsvGYCzg23q+pY=;
        b=HIbM9GEcPAdWel1GPQAYNkLrGCZXGJVyam9WRq5/TQ1aWf33WZGroJW9qfZcJtxp9X
         cv6B0kg0SgPunT8uUkpNMGGVDOkuJiMSaTGijjkbC2Aqh6l+UmLm8DmfZeBiJuO5fJNv
         bighsVOGhEoYFgW/n2hOZwZ0lYiyqJm+ShpTcr3fsNalw00g5ALeTdrFBpDPIotm7pxq
         ceNT4uZtUsYDChPAjzpaWvGLqLANbckwESIp9fA1N5zROZ2iGNyW87rue+z2bq3U/6mw
         D8/4rZG1M+44XOrfbReHp+bYXyK2u/G4a0/DNcKy06QGTA2rXSkJDTO2SJENeyZskPsk
         TZtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hdEBdEgMAGoMMquMfCuquQI2IgK+7lsvGYCzg23q+pY=;
        b=ZgCdxqCnr27sLxAe8AxUcLHMHpoQrxopJ2+usyIxkJT8/8IwFkKMHOKkqtivot6SVl
         2Siz4OsciLxASF2syJy81XFzTCkVsJD0TqNROj+4S6yVa9vVbfOWPg8p1jaPCHrUEige
         L1yOtyJ6g+AnlHHmcbdev+TRIUJ26pIFwrs37u7Fka/B/brc4CHVE/mEAfbjcqyAqRux
         o54ZbFZgwHjYi935NcwNJDTlZMNHfwLX1KMRPTTPEtyqtPpSnS5wTAHbk3sP80YTB2yt
         Q+OANu5OeSxop4OM88l2lwAkHgvjHPDbvxiQSXapRHI/1T+YXfKYrjWM9lhMdCxQEdXX
         Mcng==
X-Gm-Message-State: AOAM532ZrHI173l2Pd6kmvUh+EErPEOSPh17ZgJvmVGChp7+VI3o9tsh
        itFbMjyOePWRCRB1IG3KzfgUqOxbI8E=
X-Google-Smtp-Source: ABdhPJwYk6wfmchLYpV2XOs1LZaJURYhlU3B+hmIdXZBD8/54KTr4qo/6KZ5BqIN9+dIxA6D2k1v4g==
X-Received: by 2002:a1c:e915:0:b0:37b:d847:e127 with SMTP id q21-20020a1ce915000000b0037bd847e127mr7758594wmc.180.1645200187157;
        Fri, 18 Feb 2022 08:03:07 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id u15sm49790633wrs.18.2022.02.18.08.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Feb 2022 08:03:06 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <ad4e6ea2-df38-005a-5d60-375ec9be8c0e@redhat.com>
Date:   Fri, 18 Feb 2022 17:03:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Call for GSoC and Outreachy project ideas for summer 2022
Content-Language: en-US
To:     =?UTF-8?B?TWljaGFsIFByw612b3puw61r?= <mprivozn@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>
References: <CAJSP0QX7O_auRgTKFjHkBbkBK=B3Z-59S6ZZi10tzFTv1_1hkQ@mail.gmail.com>
 <f7dc638d-0de1-baa8-d883-fd8435ae13f2@redhat.com>
 <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <bf97384a-2244-c997-ba75-e3680d576401@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/18/22 12:39, Michal Prívozník wrote:
> On 2/17/22 18:52, Paolo Bonzini wrote:
>> I would like to co-mentor one or more projects about adding more
>> statistics to Mark Kanda's newly-born introspectable statistics
>> subsystem in QEMU
>> (https://patchew.org/QEMU/20220215150433.2310711-1-mark.kanda@oracle.com/),
>> for example integrating "info blockstats"; and/or, to add matching
>> functionality to libvirt.
>>
>> However, I will only be available for co-mentoring unfortunately.
> 
> I'm happy to offer my helping hand in this. I mean the libvirt part,
> since I am a libvirt developer.
> 
> I believe this will be listed in QEMU's ideas list, right?

Does Libvirt participate to GSoC as an independent organization this 
year?  If not, I'll add it as a Libvirt project on the QEMU ideas list.

Paolo
