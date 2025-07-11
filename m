Return-Path: <kvm+bounces-52095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D53B1B014B8
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 09:31:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F315E3A9E85
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1251EF397;
	Fri, 11 Jul 2025 07:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGEJEelw"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDD8A933;
	Fri, 11 Jul 2025 07:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752219035; cv=none; b=aLhFeozM+JymHAIa3gsg6CyE2w8zubWkWZB9R6aga1m7BJUvs7+8tZcVw4Ut59b4K+OQDFdFW1DPk1q7apkqSaJTvUG9BcU06rD96y9Om0cRtw3fUj+fpqWALZsWH/1VjlRY2GmE+kVpo2YqnSZ/cgjHOzgZ21ohEZSQPtHsvg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752219035; c=relaxed/simple;
	bh=pT4xr25h93j0ZqqII9Nj3hCTFizY/oID/swt1J6vurU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tkgBxBE3dvt9yLCwNdxy/U4Jii/cTgMhHgN9EDtXvotznNa2uuAOun2Be4G6NcZEj+W6cVvj1p9aqeTqWCqp8kNIr7aVQB7/h4UO2wSvRYMy/GOgAzE8SXR73JaVuYZSPvqyJ3Q6ovPtByrMv08ANgCJktaeXwqbhbC3/tE/8gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGEJEelw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2052C4CEED;
	Fri, 11 Jul 2025 07:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752219034;
	bh=pT4xr25h93j0ZqqII9Nj3hCTFizY/oID/swt1J6vurU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lGEJEelwUyYuRvhj82dJRzXqyXiJt/Hqq6g6H3IlCwKtFFJUvMSULkZGNjzul7iDZ
	 E2jBAkEH3Ng4wnr4fdgouMjbHMRaGvLWDXTyunnJPFYCmOIpEIerU/fWy2tDGtXMYm
	 lzTP9c3FngPwfbqG+YufABBmFtWdHzIeSL5fd/gU=
Date: Fri, 11 Jul 2025 09:30:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-spdx@vger.kernel.org
Subject: Re: [PATCH v2] powerpc: Replace the obsolete address of the FSF
Message-ID: <2025071152-name-spoon-88e8@gregkh>
References: <20250711053509.194751-1-thuth@redhat.com>
 <2025071125-talon-clammy-4971@gregkh>
 <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f7242e8-1082-4a5d-bb6e-a80106d1b1f9@redhat.com>

On Fri, Jul 11, 2025 at 09:09:08AM +0200, Thomas Huth wrote:
> On 11/07/2025 07.52, Greg Kroah-Hartman wrote:
> > On Fri, Jul 11, 2025 at 07:35:09AM +0200, Thomas Huth wrote:
> > > From: Thomas Huth <thuth@redhat.com>
> > > 
> > > The FSF does not reside in the Franklin street anymore. Let's update
> > > the address with the link to their website, as suggested in the latest
> > > revision of the GPL-2.0 license.
> > > (See https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt for example)
> > > 
> > > Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
> > > Signed-off-by: Thomas Huth <thuth@redhat.com>
> > > ---
> > >   v2: Resend with CC: linux-spdx@vger.kernel.org as suggested here:
> > >       https://lore.kernel.org/linuxppc-dev/e5de8010-5663-47f4-a2f0-87fd88230925@csgroup.eu
> > >   arch/powerpc/boot/crtsavres.S            | 5 ++---
> > >   arch/powerpc/include/uapi/asm/eeh.h      | 5 ++---
> > >   arch/powerpc/include/uapi/asm/kvm.h      | 5 ++---
> > >   arch/powerpc/include/uapi/asm/kvm_para.h | 5 ++---
> > >   arch/powerpc/include/uapi/asm/ps3fb.h    | 3 +--
> > >   arch/powerpc/lib/crtsavres.S             | 5 ++---
> > >   arch/powerpc/xmon/ppc.h                  | 5 +++--
> > >   7 files changed, 14 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/arch/powerpc/boot/crtsavres.S b/arch/powerpc/boot/crtsavres.S
> > > index 085fb2b9a8b89..a710a49a5dbca 100644
> > > --- a/arch/powerpc/boot/crtsavres.S
> > > +++ b/arch/powerpc/boot/crtsavres.S
> > > @@ -26,9 +26,8 @@
> > >    * General Public License for more details.
> > >    *
> > >    * You should have received a copy of the GNU General Public License
> > > - * along with this program; see the file COPYING.  If not, write to
> > > - * the Free Software Foundation, 51 Franklin Street, Fifth Floor,
> > > - * Boston, MA 02110-1301, USA.
> > > + * along with this program; see the file COPYING.  If not, see
> > > + * <https://www.gnu.org/licenses/>.
> > >    *
> > >    *    As a special exception, if you link this library with files
> > >    *    compiled with GCC to produce an executable, this does not cause
> > 
> > Please just drop all the "boilerplate" license text from these files,
> > and use the proper SPDX line at the top of them instead.  That is the
> > overall goal for all kernel files.
> 
> Ok, I can do that for the header files ... not quite sure about the *.S
> files though since they contain some additional text about exceptions.

That's a crazy exception, and one that should probably be talked about
with the FSF to determine exactly what the SPDX lines should be.

thanks,

greg k-h

