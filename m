Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4688B320DA
	for <lists+kvm@lfdr.de>; Sun,  2 Jun 2019 00:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbfFAWIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jun 2019 18:08:04 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:44967 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbfFAWIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jun 2019 18:08:04 -0400
Date:   Sat, 01 Jun 2019 22:07:59 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=default; t=1559426881;
        bh=sCCPTCCPsBcs7Y63lAXufXBWUSjRsNimZwh/IBz/q2g=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=sp8mbZzS2jjc1e2NLkaHUT7neDhuodg+25tbFaWHK/RhuosiK0qkgvk9WFbKI4RbM
         +Z9tdZkb8ZZXRSJG1UnXMOlfzxoaN2aNqhNDJuuqjFPeuyUGk9Q2uR/TNSnjjh99w0
         b48OKROWIlTxabCm9fGhoYC2yJ/O+/q/DRu1vW2s=
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
From:   nucleare2 <nucleare2@protonmail.com>
Reply-To: nucleare2 <nucleare2@protonmail.com>
Subject: GPU passthrough hot-swapping driver development?
Message-ID: <7m5yGq2nqhDfQvcZCjBDqj8OEu2o1QDrqiy-MdHrni7Qw8rwHrdkBMtEisMnEG1dgB6lSJI-MleT0EAlkZE28gRfQqjXJsDRlCgsNJw7oPQ=@protonmail.com>
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

Hello, I'd like to discuss the possibility of developing a method for hot-s=
wapping video cards between a KVM host and the guest machine when using pas=
sthrough.

It seems that currently passthrough is pretty restrictive as far as assignm=
ent to the host vs guest goes.  This means for applications like accelerati=
ng macOS fully a video card needs to be dedicated to passthrough for macOS =
so that native drivers grab a hold of it at macOS guest startup.

I've been thinking about the possibility of creating some kind of a dummy p=
assthrough driver that may, at some minimal level, virtualize the GPU acces=
s so as to allow the KVM host and guest (macOS, Windows, Linux, whatever wo=
uld need the full GPU access) to "hot-swap" access to the GPU.

As I said above, right now it appears that it's necessary to have multiple =
GPUs for the host vs guests that need/want passthrough, but if an appropria=
te driver is developed that somehow captures some core functionality, could=
n't a kernel level key combination capture be implemented that would flip p=
assthrough between host and guest(s)?

Basically if a macOS or Windows (or Linux) guest BELIEVES it still has cont=
rol of the GPU, then the guest kernel should not panic and should still rem=
ain operational while the host get's access.  I'm not talking about any kin=
d of capturing here, just simply making the host or guest think it's still =
getting GPU access and happily spinning away while the user is flipping bet=
ween host/guest instances.

Has anyone considered this or put any work into this so far?

I've seen someone else mention this before somewhere, but it seemed to not =
get any attention. This is a pretty critical function that would benefit KV=
M users enormously.

-nuc
