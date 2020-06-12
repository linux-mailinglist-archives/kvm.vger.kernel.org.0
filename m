Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1021E1F749D
	for <lists+kvm@lfdr.de>; Fri, 12 Jun 2020 09:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFLH3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jun 2020 03:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726290AbgFLH3v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jun 2020 03:29:51 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB6DC03E96F;
        Fri, 12 Jun 2020 00:29:50 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id d27so354774lfq.5;
        Fri, 12 Jun 2020 00:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yaY+guszQhRqACS6lpSk6VXydA5a+jEb8jU9kD9q8OQ=;
        b=Xhn0tRFKQHVe2F+mauTaMwFDuXm5bZRaGZgHSS18tN8QDEDCKF57B1emDOoibeFBiY
         qYgx8L/lqZBHNumQqGxlFPmjUNIJzr6Dhd7bnOZ2/GS0r0d3VgmcCHSc1yY4U9O1NN5G
         cnDZdGRdKM2VEtp+cVebrFtiMDncimEwcLjxY+e6wDlCI/yJCSU1Uyl3XuFkKa5KqMI1
         gJKrMpAssPstbsNTZO2Kq+OboKM+bIRI4qtoYuqyDIwvB5YIQ9q0cP76PcgSD/pNbrGV
         ee5q2yWT32+unACLWgjvdL/0nfRMVJXBfdBCKhQENXpsRJMDupGH5MrFwyBG1E8hS8a6
         vOxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yaY+guszQhRqACS6lpSk6VXydA5a+jEb8jU9kD9q8OQ=;
        b=Xcgaexs+b/pqisowS5SFQMO+FM7zkU5d2w8GUBV55+27eh1r+ufdrfLvxBYuW1XXrR
         Mjz9Z4sq9xyaSAr80VgyoQkYZuXVa/wfs89ujUsEKHwyshQ1HZl91moV7GGClVpM5kdp
         Nn11w6txpG3xMlYMIm+9U6wO1fRFoPpri5LUSCiWtflICZmnH2DuXz9K2/LZqG2X1yBj
         upQGTtbDuIYwGaYvvsnaohMSFdAMsoB7TJYmispN23qEMDYC/WQeuA6+74sS3itOFUTZ
         iE9YCGGGGUNGfHkx+w12iO0Ioxdqpag9VheJBcQC7tLn+Bz/aUbyq+DGKEG1lUm2eu5q
         Ep0Q==
X-Gm-Message-State: AOAM530X/aRyIwq+Hw0pn1NHhxGSl9BZv8+2CDRrVQ9i3RB0rdbnCbRR
        DoeuzgqChp8T6i/K403EeWVtQHyz/B/4pW2LC8WOeKrW
X-Google-Smtp-Source: ABdhPJzhILk20wQY+TBqtu2mkA6zEZW3ZYh/xaVoGtazeX6yvVotWsy5Us+YOnu9u7ttzh/H7Y4cGh1127QI5XNtNaI=
X-Received: by 2002:a19:4048:: with SMTP id n69mr6213984lfa.31.1591946988114;
 Fri, 12 Jun 2020 00:29:48 -0700 (PDT)
MIME-Version: 1.0
References: <CALKTHW0B-kpjRgJVtHwdo0sqszYzHSCH3x_Oph2gDpa0diyEVA@mail.gmail.com>
In-Reply-To: <CALKTHW0B-kpjRgJVtHwdo0sqszYzHSCH3x_Oph2gDpa0diyEVA@mail.gmail.com>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Fri, 12 Jun 2020 09:29:37 +0200
Message-ID: <CAD9gYJJx3CHSDYmTzmomGNC7BG7C5yEyrT=gk+MV44QkSs9dOA@mail.gmail.com>
Subject: Re: KVM guest freeze on Linux > 4.19
To:     Garry Filakhtov <filakhtov@gmail.com>,
        "KVM-ML (kvm@vger.kernel.org)" <kvm@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Garry Filakhtov <filakhtov@gmail.com> =E4=BA=8E2020=E5=B9=B46=E6=9C=8812=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=888:38=E5=86=99=E9=81=93=EF=BC=9A
>
> Good time of the day,
>
> Hope you all are staying safe during these challenging times.
>
> I have been struggling with KVM guest freezes after the upgrade from
> 4.19 LTS to 5.4 LTS.
>
> Searching through the internet lead me to
> https://www.reddit.com/r/VFIO/comments/b1xx0g/windows_10_qemukvm_freezes_=
after_50x_kernel_update/
> and Kernel Bugzilla revealed
> https://bugzilla.kernel.org/show_bug.cgi?id=3D200101. I have added a
> detailed problem description on the aforementioned bug.
>
> Would like to get some attention from people who might know more about
> this, and see if I need to create a brand new bug report or if that's
> okay to work through the existing bug.
>
> Also, any suggestions where else to look to find any clues that can
> help resolve the issue or identify what's causing it are highly
> appreciated.
>
> Kind regards,
> Garry Filakhtov
+cc kvm maillist
