Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487F54444E
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 18:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392551AbfFMQgF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 13 Jun 2019 12:36:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51224 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730699AbfFMQgE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 12:36:04 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A07DDC07188B;
        Thu, 13 Jun 2019 16:36:04 +0000 (UTC)
Received: from x1.home (ovpn-116-190.phx2.redhat.com [10.3.116.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 686AB54216;
        Thu, 13 Jun 2019 16:35:55 +0000 (UTC)
Date:   Thu, 13 Jun 2019 10:35:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christophe de Dinechin <cdupontd@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: mdevctl: A shoestring mediated device management and
 persistence utility
Message-ID: <20190613103555.3923e078@x1.home>
In-Reply-To: <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
References: <20190523172001.41f386d8@x1.home>
        <0358F503-E2C7-42DC-8186-34D1DA31F6D7@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 13 Jun 2019 16:36:04 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 13 Jun 2019 18:17:53 +0200
Christophe de Dinechin <cdupontd@redhat.com> wrote:

> > On 24 May 2019, at 01:20, Alex Williamson <alex.williamson@redhat.com> wrote:
> > 
> > Hi,
> > 
> > Currently mediated device management, much like SR-IOV VF management,
> > is largely left as an exercise for the user.  This is an attempt to
> > provide something and see where it goes.  I doubt we'll solve
> > everyone's needs on the first pass, but maybe we'll solve enough and
> > provide helpers for the rest.  Without further ado, I'll point to what
> > I have so far:
> > 
> > https://github.com/awilliam/mdevctl  
> 
> While it’s still early, what about :
> 
> 	mdevctl create-mdev <parent-device> <mdev-type> [<mdev-uuid>]
> 
> where if the mdev-uuid is missing, you just run uuidgen within the script?
> 
> I sent a small PR in case you think it makes sense.

It sounds racy.  If the user doesn't provide the UUID then they need to
guess that an mdev device with the same parent and type is theirs.  How
do you resolve two instances of this happening in parallel and both
coming to the same conclusion which is their device.  If a user wants
this sort of headache they can call mdevctl with `uuidgen` but I don't
think we should encourage it further.

BTW, I've moved the project to https://github.com/mdevctl/mdevctl, the
latest commit in the tree above makes that change, I've also updated
the description on my repo to point to the new location.  Thanks,

Alex
