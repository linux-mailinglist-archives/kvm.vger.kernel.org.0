Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13016204733
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 04:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731336AbgFWCUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 22:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgFWCUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 22:20:48 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8800C061573
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 19:20:46 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id g7so14991387oti.13
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 19:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=IARkd/UDkAa1kIY2+yMeRdgm/8EmYU2naHF0cYVlYoPXMPjEzskIdAE6ePjwRAN9ja
         zIDntantqwTaJ05+8LGNsodZ2PSCyug2Ff45HGEbrNeGZ7gox4AcdUu8Rq71/JpPs+oO
         vKRKcA0dJim6HHhReUu5g+BSFtf8BnWAhRXp4JWlkQJJ4LYfzyu05oY3IDDM106a7dGV
         GLRB4raW0xbR9zwMUQgnujS3TTAptHk56gxS+9deslV8Ev9Q4IR5xgXtmprG8UpKIjK5
         2oD/JyePmuQjzdhTQuZ9RU/RvAl5nezAfeKFcRiaMc+pW7SpINymCXdEz9IH0kc50FUF
         yAwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=kYya+qUM46Je8cyeglIkHCfrjyCEdDboLnUbYdk8+GpR80KHzexo29KJV2q92/O+tY
         2mMH6iE7jFK+M/HIRanhWG+sjFbveugrol/NulTwAqjfuoCeMECF9qdoYZfEj3a2lE5V
         Kb9J8CXWK1n4epnmwtBmED3oz3OwwL5SDRTvnVUN/tNBK4+FqrnbglhihZur2iqwobTC
         RDI+jasR1SlmICf+rMyj6RmfHpY/2cVRZvwfUMzz7pA1XlXX7r9QVcZNKmCtq+BGbSyq
         gxnkl11khP2dTQ1/uUZ03d0v5HwXGKq93ejd3gb0+zD3fMkNnU0Ig1xa9T1ewcgzZk43
         uw1Q==
X-Gm-Message-State: AOAM5337Mkq3FYuFtdo4ilGnF3LfqZ/YafnFBWr6qAB8v635/WGiEwiA
        f/bvgZS0UHdLxHWw4tinV5mIWKj+ZGaL5Q1fZ5hHFD5au/ZVEQ==
X-Google-Smtp-Source: ABdhPJxGZrhPrmu3wY8uy0w5T0au8Y2VzQGA6E/0IEl5QsOC3JQJgoffm8u3bl4ndMb1BAfe+dYrXvc82VxwkOPZBxA=
X-Received: by 2002:a4a:d1ac:: with SMTP id z12mr16940451oor.60.1592878845853;
 Mon, 22 Jun 2020 19:20:45 -0700 (PDT)
MIME-Version: 1.0
From:   Li Qiang <liq3ea@gmail.com>
Date:   Tue, 23 Jun 2020 10:20:10 +0800
Message-ID: <CAKXe6S+LJfcMa6cnpu-=YyAcBeux5e-QfEFh9VtSY7QSgrn2RQ@mail.gmail.com>
Subject: 
To:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

subscribe kvm
