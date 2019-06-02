Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0436324DB
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 22:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfFBU5L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 2 Jun 2019 16:57:11 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:30056 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726305AbfFBU5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Jun 2019 16:57:11 -0400
Date:   Sun, 02 Jun 2019 20:57:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1559509029;
        bh=xZHePW2v1GxEJR2Mn3XEzku2RtnAk7WkLIE9JqAYoBQ=;
        h=Date:To:From:Reply-To:Subject:In-Reply-To:References:Feedback-ID:
         From;
        b=lLX9hpUGgGX73GHziyeRyl0jlcjnRnqTU75iziZH4nZHoHG9ZqHGXn0ECPpYfXD6y
         6mYDNR3tITU2uABEkqc3+CUrQSzMnM30U5vXddkg545mu6Z9y1IwimcnWIBAXQgEWM
         XB9KO+8rN/FXuHWePI0ynlYZA7j273UFewH1ZoGE=
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   nucleare2 <nucleare2@protonmail.com>
Reply-To: nucleare2 <nucleare2@protonmail.com>
Subject: Re: GPU passthrough hot-swapping driver development?
Message-ID: <ysJaGhqbez5HgpIiFS8dL6S5MliNEX4WRDXeZJFcKZ0qrtdPueXqljeLDcHvDOeJGKsPWvcMJv3TU6PFlhqHGeKXJSXwxJ84mzNAw4AfDhQ=@protonmail.com>
In-Reply-To: <NSZOGDLSVPu40Ch8eOrf0JQaHx53jz3bJr3ObXdpT6riMCAcivu6wVdRC61HE1fkMnOMTUIysb00W4BqDhpIg3EALXCHPl_ZCECBRtGNstI=@protonmail.com>
References: <7m5yGq2nqhDfQvcZCjBDqj8OEu2o1QDrqiy-MdHrni7Qw8rwHrdkBMtEisMnEG1dgB6lSJI-MleT0EAlkZE28gRfQqjXJsDRlCgsNJw7oPQ=@protonmail.com>
 <NSZOGDLSVPu40Ch8eOrf0JQaHx53jz3bJr3ObXdpT6riMCAcivu6wVdRC61HE1fkMnOMTUIysb00W4BqDhpIg3EALXCHPl_ZCECBRtGNstI=@protonmail.com>
Feedback-ID: 6cK2ugpeksPec3rG16mXEaHR9GhrR_B-m0z3L-xAiYND-P5vD9hHafIOg6bgnbygXCX6rz6IkScptBLgDrGM0A==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(I believe my last message may have been garbled from the way it's looking =
on MARC so I'm going to resend that message WITHOUT the inline diagrams (ju=
st links to images)...)

Given that there's been no response yet, I wanted to hopefully clarify what=
 I'm talking about by providing a couple diagrams and maybe some clarifying=
 terminology. I'm not sure if these diagrams will look right for everyone, =
so I'll also include a link to an image for each one above it.

First, please correct me if I'm wrong, but I believe the following diagram =
represents a very basic visualization of KVM + QEMU:

IMAGE: https://i.ibb.co/smh9Rv4/KVM-and-QEMU.png

What I'm considering or asking about is the development of something I'll c=
all a "soft video switch" within Linux that perhaps lives beside KVM or som=
ehow works with KVM to facilitate quick switching between direct passthroug=
h of graphics for the HOST or GUEST(s):

IMAGE: https://i.ibb.co/gSLybZy/KVM-and-QEMU-with-soft-video-switch.png

If I'm missing any diagrammatic details, I would very much appreciate some =
correction.  Further, I'd like to discuss what could stop the development o=
f such a "soft video switch" as explained above.


Thanks for any input here!

-nuc


> =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original =
Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
> On Saturday, June 1, 2019 6:07 PM, nucleare2 nucleare2@protonmail.com wro=
te:
>
> > Hello, I'd like to discuss the possibility of developing a method for h=
ot-swapping video cards between a KVM host and the guest machine when using=
 passthrough.
> > It seems that currently passthrough is pretty restrictive as far as ass=
ignment to the host vs guest goes. This means for applications like acceler=
ating macOS fully a video card needs to be dedicated to passthrough for mac=
OS so that native drivers grab a hold of it at macOS guest startup.
> > I've been thinking about the possibility of creating some kind of a dum=
my passthrough driver that may, at some minimal level, virtualize the GPU a=
ccess so as to allow the KVM host and guest (macOS, Windows, Linux, whateve=
r would need the full GPU access) to "hot-swap" access to the GPU.
> > As I said above, right now it appears that it's necessary to have multi=
ple GPUs for the host vs guests that need/want passthrough, but if an appro=
priate driver is developed that somehow captures some core functionality, c=
ouldn't a kernel level key combination capture be implemented that would fl=
ip passthrough between host and guest(s)?
> > Basically if a macOS or Windows (or Linux) guest BELIEVES it still has =
control of the GPU, then the guest kernel should not panic and should still=
 remain operational while the host get's access. I'm not talking about any =
kind of capturing here, just simply making the host or guest think it's sti=
ll getting GPU access and happily spinning away while the user is flipping =
between host/guest instances.
> > Has anyone considered this or put any work into this so far?
> > I've seen someone else mention this before somewhere, but it seemed to =
not get any attention. This is a pretty critical function that would benefi=
t KVM users enormously.
> > -nuc


