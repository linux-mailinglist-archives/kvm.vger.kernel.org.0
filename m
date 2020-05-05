Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750DB1C53EA
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 13:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgEELHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 07:07:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45856 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725766AbgEELHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 07:07:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588676854;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=m3bA68ec7aJml5ryrkpGt9Ig1LpeVBADh46vzuQRoAA=;
        b=MY/Z/5XVrMRm4zKxqGe2Z+VxgaZireAi3uV90HimMU8uX05VZ2FWMMsr8PsG7pIcQUVF6p
        stdaHDifMPjoaZj7U3VCK3QdciVAyCRuVkTRg8aQ8eFxNKXE0c08pzIF2HsZ+Izo0RouzT
        /k8Lrtz5GlUl1YP8I60N70OQMUTq/QY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-177-QLxUj5ZcMHyiZ9xIHrwqng-1; Tue, 05 May 2020 07:07:32 -0400
X-MC-Unique: QLxUj5ZcMHyiZ9xIHrwqng-1
Received: by mail-wm1-f70.google.com with SMTP id h6so875227wmi.7
        for <kvm@vger.kernel.org>; Tue, 05 May 2020 04:07:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:user-agent:reply-to:date
         :message-id:mime-version;
        bh=m3bA68ec7aJml5ryrkpGt9Ig1LpeVBADh46vzuQRoAA=;
        b=HWFkKhK0Fc4a9Uqs9coDC5eg3IvJqtwarEc2pRP2O1jahECltD5tM0zhVNmXyMarFy
         MyuKdGs2N32JGxNgKLr8HCpWxONM9D8zR7pYyDc+3UoPlze0RSYJd3N+t4xpjyF3wtwZ
         8wQwZ83gETeaq1Qi3eY7m4qunq39hr4kToGCfxZNbbusP0gUEqHreD7I+7NHb5W64+ip
         dDMPAnFq15rwpsl++QDwPMKrLMXeFyqDeKLFd+s1asrS14YkjNWw7bNh6im6gIhBd2Pl
         gEaYe+6Hslw5yY/LHNv9JgPxiuSl7tzDf1ow/NpK38Tdg+Jw8dNfg8MVu3wrdnpvVJZO
         E6mg==
X-Gm-Message-State: AGi0PuZiWMmzi2lIC2hQwwT8vc7xdbe4rOU7gsG2dqS5Vg0enx0v/+/S
        W2PJG21Zc2zgs9iej6qS0iNLvVdJsqzyS8oT/I3jL3aUlXuKD7O2Mk/USTTS3XA3gNN+WXJF2xq
        7M+bJLnqx25RP
X-Received: by 2002:a1c:bc05:: with SMTP id m5mr2531717wmf.143.1588676851643;
        Tue, 05 May 2020 04:07:31 -0700 (PDT)
X-Google-Smtp-Source: APiQypILdwtkxnuPE3FDz6NiBdV3FIPkHW9bo4jcwFh56XElEqBE0ePyzvx4rn6ssrZ8iH+8iAiT9Q==
X-Received: by 2002:a1c:bc05:: with SMTP id m5mr2531702wmf.143.1588676851460;
        Tue, 05 May 2020 04:07:31 -0700 (PDT)
Received: from localhost (trasno.trasno.org. [83.165.45.250])
        by smtp.gmail.com with ESMTPSA id x6sm2722021wrv.57.2020.05.05.04.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 04:07:30 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Today KVM external call canceled
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 05 May 2020 13:07:29 +0200
Message-ID: <87sgge4p3i.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

As there are no topics, we cancel that call.

Happy hacking.

