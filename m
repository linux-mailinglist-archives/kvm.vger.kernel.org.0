Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA68DA71D
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2019 10:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405179AbfJQIUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Oct 2019 04:20:18 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:35397 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405166AbfJQIUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Oct 2019 04:20:18 -0400
Received: by mail-qk1-f175.google.com with SMTP id w2so1108092qkf.2
        for <kvm@vger.kernel.org>; Thu, 17 Oct 2019 01:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=VLr6A+GuHyShcjJPiDYAx6zRrDRm2jat2pVrt52z7rw=;
        b=HEFM2JxRbwJBxT9d6kfBnsn22htAT0iRI+fDialpmw3GyCpgc0J7QU+xiqyzrK/Gaz
         YqarWOIUlzdqyDpa1qRGYW9tN0cewh9+ege9+HSY/1v/112lwVKsP4iRktO/wi9bzPoI
         yS44/kwKz9BKYPVdkMfjYu9YhaAICCABCkOaOo5BVVfCsSOBJeNaB1gY3bc7XymcG9V4
         lKwwl2WHJMsXlmq93F2RKQE5G2+szddMWgg2JHrI2JaC1056LQh0pAm93tQZh3f3rwnG
         Z0MEN2CPQp0gFR93N2kKrV+gsMK9ZZ+b90kmfrCp3PSPRpfFZbwFL8SSYCGHZbUJrugq
         QQyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VLr6A+GuHyShcjJPiDYAx6zRrDRm2jat2pVrt52z7rw=;
        b=TNHlEQyNgvawLZVlMkHSeep2BPNSpYNVevJvcoIWwuA1ueoW6f9DUVgQDtybWqvBbD
         cKiCog8zEujP9xv3YHeZ1nMnKtfdtxDAiY1bFNMJfgb7EuteXMa+NHEVLEaQ0ZRB2Eni
         VP0HUU/n0w2VqTuZjxIN9h7e4Mx8z4RQf9SQYjBOivAvpaTbnLcXcyF8QAwqGyIprBzM
         /g59xv/HpdT6bebtMMUC298OGfstwWCZG7SMS8aF86h/KZnbcfdE0NQFEwganrW6JVdi
         LP9ZPdPHuRd4zhyXroEqE09mC3LwnLI62Icvjr0WSYmZrqOM3gzrD9zqHDi8iTSy84lj
         xqsg==
X-Gm-Message-State: APjAAAXRzRwsIJzMvgufUtBBu4sQ5nBzb19fpY0GTvZbU7z4pmbCYy1h
        ehQF0je6EYWw3trSldOG9gwgHLPz5vX/aWqb+LhJwjyOp1g=
X-Google-Smtp-Source: APXvYqzptmso4QWc4fzonqbnWa+zMj2dQpARVfJyzKJuMaq0IjKCqIhX04Nmo8CYPUaahjL9WCyuFIlqBcQchSNfaJA=
X-Received: by 2002:a37:a345:: with SMTP id m66mr2066441qke.487.1571300416088;
 Thu, 17 Oct 2019 01:20:16 -0700 (PDT)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Thu, 17 Oct 2019 09:20:05 +0100
Message-ID: <CAJSP0QWchnsEqCFiPr9-axrAx3rF6HxDBQ0HUgSg3WriVqSusw@mail.gmail.com>
Subject: [Call for Presentations] FOSDEM 2020 Virtualization & IaaS Devroom
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The FOSDEM open source developer conference is taking place in
Brussels, Belgium on February 1st & 2nd, 2020.  The call for
virtualization presentations has been posted:

https://lists.fosdem.org/pipermail/fosdem/2019q4/002889.html

I just wanted to forward this because the CfP only went to
qemu-discuss where developers may have missed it.  Hope to see you at
FOSDEM!

Stefan
