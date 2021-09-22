Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDD2414A77
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbhIVNY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:24:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbhIVNYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 09:24:24 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919B6C06175F
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 06:22:53 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id z24so11730840lfu.13
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 06:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=8jjVBTnsAfwW5TmGCW6uV+TD16a8deW3SPhpYsIJnXw=;
        b=WZDktdzXKFKUYWKYT3Sp5zdSVdCzSlymcoU4J+FZX5KfK4d9na21JCNdgu5awQgsg8
         8WGIDi2PZGSRYKPL2pzcpr4MieTGAgALA6HeMSNo5Uv5pL43v4jNCXpt90+0rq+ro6Bb
         e4D9g7AJ4FIGQXdUF3W26s9raaIu0qcy6Ja3FMaQ6HkIlC64Dsfwkn0bICrpENYbXlux
         lL2VXRpE/fSQINi0mr68NhT1VGBAs/euhORtXlFfg30SdZsrpgI6afrYFJqgLSpYfcAE
         LdErHLNeBXgwKrnntc3GIMcrkPqCzqCgApcOQA6WlJjX/BnuI59Z1V1ZQCjYYl790GHK
         268g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=8jjVBTnsAfwW5TmGCW6uV+TD16a8deW3SPhpYsIJnXw=;
        b=H1odUOua9HMtWPhQKalX5zHtQlOOnmoTTftTpn4II9PHKFhtpfW7imyUqMl9puP8Nq
         X033Kxavipj2z34bZAMyQzoTUFf4yAJJPXHteZhey+id83nPSxTE6zcvFL7FeGzJzLuq
         SGoqUzugt6fwowdwYghJ8IH5RLsGejSD4nx+n2+1w+xfXU+LtRcavJpUmxsbJyuOHzJd
         6WPSmBGJBC5r5koHDDGfa5X5+fq4U7YlweLK0CR2BHAkCxMpNW5TMsUdBWQvxXnp9g7Z
         5UeP6Dgc2U5v7CwlKAGf0o0RN4d9VG38g9jk1l9UUtMZ2dd1fIXTKBkF614n9j3ZfkgC
         a5tQ==
X-Gm-Message-State: AOAM531ZC4mFL+8wrO8yvBSJXeOGDOjXrryGbFis3q7DIQg226EFPHmR
        v9BuvxNqFOEtgFgDH1SEuKf7ePl/zAYgqA==
X-Google-Smtp-Source: ABdhPJyr9fPsQLGUPwqaGa5rxPvFxKb0y23meqjkqfVRPCmyj8mDc9Wm6SSDVurJpcViSLQOiwvMUA==
X-Received: by 2002:a05:6512:3091:: with SMTP id z17mr27263086lfd.246.1632316967659;
        Wed, 22 Sep 2021 06:22:47 -0700 (PDT)
Received: from [192.168.32.189] (host-95-197-17-240.mobileonline.telia.com. [95.197.17.240])
        by smtp.gmail.com with ESMTPSA id s8sm253254ljh.79.2021.09.22.06.22.46
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 06:22:47 -0700 (PDT)
To:     kvm@vger.kernel.org
From:   mattias <mjonsson1986@gmail.com>
Subject: vhd file with windows
Message-ID: <4f679440-113d-60be-4c84-e5cfaffab4ca@gmail.com>
Date:   Wed, 22 Sep 2021 15:22:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

if i have a vhd image created by e.g virtualbox

can i boot it with kvm?

