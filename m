Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA4C1903A5
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 03:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCXCjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 22:39:35 -0400
Received: from nwk-aaemail-lapp01.apple.com ([17.151.62.66]:38702 "EHLO
        nwk-aaemail-lapp01.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726824AbgCXCjf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 22:39:35 -0400
X-Greylist: delayed 15768 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Mar 2020 22:39:34 EDT
Received: from pps.filterd (nwk-aaemail-lapp01.apple.com [127.0.0.1])
        by nwk-aaemail-lapp01.apple.com (8.16.0.27/8.16.0.27) with SMTP id 02NMBpcm010840;
        Mon, 23 Mar 2020 15:18:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=sender : content-type
 : mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to; s=20180706;
 bh=Y02nwKR4JH2JH1QU0OOObT/hzr7Ij+7CN0wVPqUYHYI=;
 b=uouoWIFKdUQeqq7gdWrijXT92YGrABuy5YtXE1/IQlCbMM/SinxdDZsEHHHG2Y1LFshu
 N0HE2ysynh73ezcfh4zOz0D9ZO7dsqmCpD0KWFX/0QY6qU2+BEdZuet0qChhY1UIViHj
 ShGyazUBPurCjuotYgJDikoVw7YBrtELl395zeurlCBjXFPJ8OU48XTtUDn2V1uRB7Uq
 99+ppkdrMh3h4EnBkqLf0CG8mXcnfVV6XfqET8OjDrbQrO/132SiBRXz8c0tzC6dbY+X
 Cs+QLX0ldtOqRBud+65yfs1nlDN1Vz4ST9PJWjLYUGE8iyK0wYSkDvtgr2VBh5Trpj8i QA== 
Received: from rn-mailsvcp-mta-lapp01.rno.apple.com (rn-mailsvcp-mta-lapp01.rno.apple.com [10.225.203.149])
        by nwk-aaemail-lapp01.apple.com with ESMTP id 2ywhv1vjsb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Mon, 23 Mar 2020 15:18:35 -0700
Received: from rn-mailsvcp-mmp-lapp01.rno.apple.com
 (rn-mailsvcp-mmp-lapp01.rno.apple.com [17.179.253.14])
 by rn-mailsvcp-mta-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) with ESMTPS id <0Q7O010VA3AZS140@rn-mailsvcp-mta-lapp01.rno.apple.com>;
 Mon, 23 Mar 2020 15:18:35 -0700 (PDT)
Received: from process_milters-daemon.rn-mailsvcp-mmp-lapp01.rno.apple.com by
 rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020)) id <0Q7O00S00330T100@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Mon,
 23 Mar 2020 15:18:35 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 20c0c410705af0c5efefeb0380f25862
X-Va-E-CD: 387ecfb7ab0747708db2164576985b4f
X-Va-R-CD: 69b21bf0b03d2df56ee05a4e86925f9e
X-Va-CD: 0
X-Va-ID: f510cce3-5a5a-4f26-86c4-980b22270f43
X-V-A:  
X-V-T-CD: 20c0c410705af0c5efefeb0380f25862
X-V-E-CD: 387ecfb7ab0747708db2164576985b4f
X-V-R-CD: 69b21bf0b03d2df56ee05a4e86925f9e
X-V-CD: 0
X-V-ID: bd920c99-aa4b-4cdb-97fa-0a10216d08e6
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_09:2020-03-23,2020-03-23 signatures=0
Received: from [17.234.34.141] (unknown [17.234.34.141])
 by rn-mailsvcp-mmp-lapp01.rno.apple.com
 (Oracle Communications Messaging Server 8.1.0.5.20200312 64bit (built Mar 12
 2020))
 with ESMTPSA id <0Q7O008LY3AZKN30@rn-mailsvcp-mmp-lapp01.rno.apple.com>; Mon,
 23 Mar 2020 15:18:35 -0700 (PDT)
Content-type: text/plain; charset=us-ascii
MIME-version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [kvm-unit-tests PATCH 0/2] Add support of hvf accel
From:   Cameron Esfahani <dirty@apple.com>
In-reply-to: <20200320153751.GF77771@SPB-NB-133.local>
Date:   Mon, 23 Mar 2020 15:18:34 -0700
Cc:     kvm@vger.kernel.org
Content-transfer-encoding: quoted-printable
Message-id: <506BA256-2057-435F-B3A0-C31490A8123E@apple.com>
References: <20200320145541.38578-1-r.bolshakov@yadro.com>
 <20200320153751.GF77771@SPB-NB-133.local>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
X-Mailer: Apple Mail (2.3445.104.11)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_09:2020-03-23,2020-03-23 signatures=0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first sentence doesn't make much sense.  HVF is not QEMU specific.  =
Other VMMs use it.

Cameron Esfahani
dirty@apple.com

"The cake is a lie."

Common wisdom



> On Mar 20, 2020, at 8:37 AM, Roman Bolshakov <r.bolshakov@yadro.com> =
wrote:
>=20
> I'm sorry for broken formating in the cover letter. Here's a reformat =
at
> your convenience.
>=20
> HVF is a para-virtualized QEMU accelerator for macOS based on
> Hypervisor.framework (HVF). Hypervisor.framework is a thin user-space
> wrapper around Intel VT/VMX that enables to run VMMs such as QEMU in
> non-privileged mode.
>=20
> The unit tests can be run on macOS to verify completeness of the HVF
> accel implementation.
>=20
> Regards,
> Roman

