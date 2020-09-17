Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7A726E543
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 21:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgIQTRP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 15:17:15 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:42087 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726453AbgIQTQm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 15:16:42 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 15:16:40 EDT
Received: from [192.168.100.1] ([82.252.129.222]) by mrelayeu.kundenserver.de
 (mreue108 [213.165.67.119]) with ESMTPSA (Nemesis) id
 1MLR9p-1k0d6T3gRf-00IXZO; Thu, 17 Sep 2020 21:02:07 +0200
Subject: Re: [PATCH 0/6] misc: Some inclusive terminology changes
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Joel Stanley <joel@jms.id.au>, qemu-trivial@nongnu.org,
        qemu-arm@nongnu.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Richard Henderson <rth@twiddle.net>
References: <20200910070131.435543-1-philmd@redhat.com>
From:   Laurent Vivier <laurent@vivier.eu>
Autocrypt: addr=laurent@vivier.eu; prefer-encrypt=mutual; keydata=
 mQINBFYFJhkBEAC2me7w2+RizYOKZM+vZCx69GTewOwqzHrrHSG07MUAxJ6AY29/+HYf6EY2
 WoeuLWDmXE7A3oJoIsRecD6BXHTb0OYS20lS608anr3B0xn5g0BX7es9Mw+hV/pL+63EOCVm
 SUVTEQwbGQN62guOKnJJJfphbbv82glIC/Ei4Ky8BwZkUuXd7d5NFJKC9/GDrbWdj75cDNQx
 UZ9XXbXEKY9MHX83Uy7JFoiFDMOVHn55HnncflUncO0zDzY7CxFeQFwYRbsCXOUL9yBtqLer
 Ky8/yjBskIlNrp0uQSt9LMoMsdSjYLYhvk1StsNPg74+s4u0Q6z45+l8RAsgLw5OLtTa+ePM
 JyS7OIGNYxAX6eZk1+91a6tnqfyPcMbduxyBaYXn94HUG162BeuyBkbNoIDkB7pCByed1A7q
 q9/FbuTDwgVGVLYthYSfTtN0Y60OgNkWCMtFwKxRaXt1WFA5ceqinN/XkgA+vf2Ch72zBkJL
 RBIhfOPFv5f2Hkkj0MvsUXpOWaOjatiu0fpPo6Hw14UEpywke1zN4NKubApQOlNKZZC4hu6/
 8pv2t4HRi7s0K88jQYBRPObjrN5+owtI51xMaYzvPitHQ2053LmgsOdN9EKOqZeHAYG2SmRW
 LOxYWKX14YkZI5j/TXfKlTpwSMvXho+efN4kgFvFmP6WT+tPnwARAQABtCJMYXVyZW50IFZp
 dmllciA8bGF1cmVudEB2aXZpZXIuZXU+iQI4BBMBAgAiBQJWBTDeAhsDBgsJCAcDAgYVCAIJ
 CgsEFgIDAQIeAQIXgAAKCRDzDDi9Py++PCEdD/oD8LD5UWxhQrMQCsUgLlXCSM7sxGLkwmmF
 ozqSSljEGRhffxZvO35wMFcdX9Z0QOabVoFTKrT04YmvbjsErh/dP5zeM/4EhUByeOS7s6Yl
 HubMXVQTkak9Wa9Eq6irYC6L41QNzz/oTwNEqL1weV1+XC3TNnht9B76lIaELyrJvRfgsp9M
 rE+PzGPo5h7QHWdL/Cmu8yOtPLa8Y6l/ywEJ040IoiAUfzRoaJs2csMXf0eU6gVBhCJ4bs91
 jtWTXhkzdl4tdV+NOwj3j0ukPy+RjqeL2Ej+bomnPTOW8nAZ32dapmu7Fj7VApuQO/BSIHyO
 NkowMMjB46yohEepJaJZkcgseaus0x960c4ua/SUm/Nm6vioRsxyUmWd2nG0m089pp8LPopq
 WfAk1l4GciiMepp1Cxn7cnn1kmG6fhzedXZ/8FzsKjvx/aVeZwoEmucA42uGJ3Vk9TiVdZes
 lqMITkHqDIpHjC79xzlWkXOsDbA2UY/P18AtgJEZQPXbcrRBtdSifCuXdDfHvI+3exIdTpvj
 BfbgZAar8x+lcsQBugvktlQWPfAXZu4Shobi3/mDYMEDOE92dnNRD2ChNXg2IuvAL4OW40wh
 gXlkHC1ZgToNGoYVvGcZFug1NI+vCeCFchX+L3bXyLMg3rAfWMFPAZLzn42plIDMsBs+x2yP
 +bkCDQRWBSYZARAAvFJBFuX9A6eayxUPFaEczlMbGXugs0mazbOYGlyaWsiyfyc3PStHLFPj
 rSTaeJpPCjBJErwpZUN4BbpkBpaJiMuVO6egrC8Xy8/cnJakHPR2JPEvmj7Gm/L9DphTcE15
 92rxXLesWzGBbuYxKsj8LEnrrvLyi3kNW6B5LY3Id+ZmU8YTQ2zLuGV5tLiWKKxc6s3eMXNq
 wrJTCzdVd6ThXrmUfAHbcFXOycUyf9vD+s+WKpcZzCXwKgm7x1LKsJx3UhuzT8ier1L363RW
 ZaJBZ9CTPiu8R5NCSn9V+BnrP3wlFbtLqXp6imGhazT9nJF86b5BVKpF8Vl3F0/Y+UZ4gUwL
 d9cmDKBcmQU/JaRUSWvvolNu1IewZZu3rFSVgcpdaj7F/1aC0t5vLdx9KQRyEAKvEOtCmP4m
 38kU/6r33t3JuTJnkigda4+Sfu5kYGsogeYG6dNyjX5wpK5GJIJikEhdkwcLM+BUOOTi+I9u
 tX03BGSZo7FW/J7S9y0l5a8nooDs2gBRGmUgYKqQJHCDQyYut+hmcr+BGpUn9/pp2FTWijrP
 inb/Pc96YDQLQA1q2AeAFv3Rx3XoBTGl0RCY4KZ02c0kX/dm3eKfMX40XMegzlXCrqtzUk+N
 8LeipEsnOoAQcEONAWWo1HcgUIgCjhJhBEF0AcELOQzitbJGG5UAEQEAAYkCHwQYAQIACQUC
 VgUmGQIbDAAKCRDzDDi9Py++PCD3D/9VCtydWDdOyMTJvEMRQGbx0GacqpydMEWbE3kUW0ha
 US5jz5gyJZHKR3wuf1En/3z+CEAEfP1M3xNGjZvpaKZXrgWaVWfXtGLoWAVTfE231NMQKGoB
 w2Dzx5ivIqxikXB6AanBSVpRpoaHWb06tPNxDL6SVV9lZpUn03DSR6gZEZvyPheNWkvz7bE6
 FcqszV/PNvwm0C5Ju7NlJA8PBAQjkIorGnvN/vonbVh5GsRbhYPOc/JVwNNr63P76rZL8Gk/
 hb3xtcIEi5CCzab45+URG/lzc6OV2nTj9Lg0SNcRhFZ2ILE3txrmI+aXmAu26+EkxLLfqCVT
 ohb2SffQha5KgGlOSBXustQSGH0yzzZVZb+HZPEvx6d/HjQ+t9sO1bCpEgPdZjyMuuMp9N1H
 ctbwGdQM2Qb5zgXO+8ZSzwC+6rHHIdtcB8PH2j+Nd88dVGYlWFKZ36ELeZxD7iJflsE8E8yg
 OpKgu3nD0ahBDqANU/ZmNNarBJEwvM2vfusmNnWm3QMIwxNuJghRyuFfx694Im1js0ZY3LEU
 JGSHFG4ZynA+ZFUPA6Xf0wHeJOxGKCGIyeKORsteIqgnkINW9fnKJw2pgk8qHkwVc3Vu+wGS
 ZiJK0xFusPQehjWTHn9WjMG1zvQ5TQQHxau/2FkP45+nRPco6vVFQe8JmgtRF8WFJA==
Message-ID: <58370210-1ff8-4ec2-553b-7693a9b85c99@vivier.eu>
Date:   Thu, 17 Sep 2020 21:02:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200910070131.435543-1-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vSkFfUIMLAFpwGxD4kzvP0Wh7o/G0mxbO0B+DlLdDBHKRvz3KBg
 by18GcAinCDBchxvJZiG2Ykd6g3Ry7XjzcakL2FonD/2CSA/TW4LJ38ZjUr7IaP/5/Mn8IZ
 EI8L+dPqGkqFzeT3VI1Zv1EpZaKk9lf8AAh6UqoJhg29yQTxnWJAzVdtXkIq/rENklDwAMc
 1PZk4LpgwNS6tcdOuSOpQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y30/iYU2RuU=:sndiwD5TrHqYZfq5/lHooU
 zh8GPi9eJb2j+GXwkrljiC2vE9+LxQSq7U0yOQC+CcChlhQaR1DuZjM2ewmzCQ/sCLfYaRC+B
 YuP7ugrAC6SP95DG4VCs1JeUPBNa6aTfCcq9mORtWqo5SfaGZ//wGkOnE6ROtGiBW+p7zoF1m
 jRo8jQHfU0GqSseEicigNPZHm5oEBqjQVBm6JQvBG9uROriTrqk4rHzQG/rbw+DwzXkmFwRBE
 1rINZ6ls02JqBQa04zQrh0llyUk8F8lljqwzXfFYde/A0uDI2gVWrpMElzE1IFvUrTAWmr+WV
 /Yhpg0PGyYhtTmJ5YOGrwFeo0kTSpeBcaR816WzVG1cO4cfw9nR7gezdJ87dYRBf546w2W/OB
 OiHuxKPGCFRrz9DD8kTdyDXo2rnqJGY6x/z9Mw1CjmqDo/1kFDW9TbM/ndUTpG8OJZ+eQG4A9
 VmrEsYbDvDAjwwO4IOr6Ka9Ylv+ky1lvfj73o41DKnvtJcEmUfgNHyKUfTpyzTeN4CeUupRz+
 p3RML3O8hmbUQIVr7qWa8VILcncqt04sa52vlbb1piGeSaCTky1uhxpkwmpOIeDVpL1+C+Nvi
 o3Kf5YeovYqiW/FOzl3sZ+dKlMythcLkXZ7S/QN9l6lVWBI2Fp76ntUKuseslG7bCE8vAJh5h
 yU8ipCPwge53BK+KT8Fz3rJ67dMsNkc8USzH68sh8/BwnatvXRXOvHWtrj1rYb5XtLILI08T1
 JSGbXdGxnqU0h74z3nZ1OUHvOknOBCbL6lrzlWj8PAAxPM9Nj1E8uoN5sp5e0RqemopQMVPMP
 36ZAbypLJIk4WdoURkIwpZIZvsnMQhaCJ334w/HQBhiRLVWdp8S/3doJBFIMF7oePR2nx1/
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Le 10/09/2020 à 09:01, Philippe Mathieu-Daudé a écrit :
> We don't have (yet?) inclusive terminology guidelines,
> but the PCI hole memory is not "black", the DMA sources
> don't stream to "slaves", and there isn't really a TSX
> "black" list, we only check for broken fields.
> 
> As this terms can be considered offensive, and changing
> them is a no-brain operation, simply do it.
> 
> Philippe Mathieu-Daudé (6):
>   hw/ssi/aspeed_smc: Rename max_slaves as max_devices
>   hw/core/stream: Rename StreamSlave as StreamSink
>   hw/dma/xilinx_axidma: Rename StreamSlave as StreamSink
>   hw/net/xilinx_axienet: Rename StreamSlave as StreamSink
>   hw/pci-host/q35: Rename PCI 'black hole as '(memory) hole'
>   target/i386/kvm: Rename host_tsx_blacklisted() as host_tsx_broken()
> 
>  include/hw/pci-host/q35.h     |  4 +--
>  include/hw/ssi/aspeed_smc.h   |  2 +-
>  include/hw/ssi/xilinx_spips.h |  2 +-
>  include/hw/stream.h           | 46 +++++++++++++--------------
>  hw/core/stream.c              | 20 ++++++------
>  hw/dma/xilinx_axidma.c        | 58 +++++++++++++++++------------------
>  hw/net/xilinx_axienet.c       | 44 +++++++++++++-------------
>  hw/pci-host/q35.c             | 38 +++++++++++------------
>  hw/ssi/aspeed_smc.c           | 40 ++++++++++++------------
>  hw/ssi/xilinx_spips.c         |  2 +-
>  target/i386/kvm.c             |  4 +--
>  tests/qtest/q35-test.c        |  2 +-
>  12 files changed, 131 insertions(+), 131 deletions(-)
> 

Philippe,

Could you report your series: it doesn't apply cleanly on my branch.

Thanks,
Laurent
