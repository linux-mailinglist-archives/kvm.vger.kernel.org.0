Return-Path: <kvm+bounces-52090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4BDDB01305
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 07:52:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E03441C83716
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 05:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 870BC1CF5C0;
	Fri, 11 Jul 2025 05:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvigZfao"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F19D1B87C9;
	Fri, 11 Jul 2025 05:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752213148; cv=none; b=fAhthBgasJeyTPjoa4rEfPZaGrZz1p7MYSrdpNlt7LGgkWsbhN2E34t8xkaFMVdj5KFi1hB2PobHXJ9Wa+GQpYkXO33IsmHgnOS3a/cj15HPTZ17+JSTbvaErhBXy/yoArbDzaZt0Wortu4sDiG+y/BYrgdsP+EPYLaTR+XRWi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752213148; c=relaxed/simple;
	bh=GalF7X4tEOCU7yqLuZS+dTBOvpTY6VBkPegdXd1d4f0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTrV90F696Lmzx8GXUZRgqKJw/NIoDNxBdgzZ4r0mwguUl8TASMAzG8U9AwwuP8TqcDPI7Nwybz4OXrC98+1MX6oOCpDyBenG7ODPS+NQeHE6LTzaAot2b8AJOk/0tTEGAy/hTQ9aqoY0LZLes0Wnk2Xw/3p7KVyqREr9i9J0Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvigZfao; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C586CC4CEED;
	Fri, 11 Jul 2025 05:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752213148;
	bh=GalF7X4tEOCU7yqLuZS+dTBOvpTY6VBkPegdXd1d4f0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XvigZfaoKZQ1bTxPtiORTiC85gXzd7tvxH+bBbT6xdC5Dm8qzEeu+78cq1NEYb/HN
	 +LACQR7M0dZLheoogtIyhwfRCGfg2TKue6huk8v+TF/E1FKehTN2IVlHlG7CAcSSnG
	 Kg14u4UgHAE98ZoySQ0BTj+JkJEF0HYTZZH92kIk=
Date: Fri, 11 Jul 2025 07:52:24 +0200
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
Message-ID: <2025071125-talon-clammy-4971@gregkh>
References: <20250711053509.194751-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250711053509.194751-1-thuth@redhat.com>

On Fri, Jul 11, 2025 at 07:35:09AM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> The FSF does not reside in the Franklin street anymore. Let's update
> the address with the link to their website, as suggested in the latest
> revision of the GPL-2.0 license.
> (See https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt for example)
> 
> Acked-by: Segher Boessenkool <segher@kernel.crashing.org>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  v2: Resend with CC: linux-spdx@vger.kernel.org as suggested here:
>      https://lore.kernel.org/linuxppc-dev/e5de8010-5663-47f4-a2f0-87fd88230925@csgroup.eu
>      
>  arch/powerpc/boot/crtsavres.S            | 5 ++---
>  arch/powerpc/include/uapi/asm/eeh.h      | 5 ++---
>  arch/powerpc/include/uapi/asm/kvm.h      | 5 ++---
>  arch/powerpc/include/uapi/asm/kvm_para.h | 5 ++---
>  arch/powerpc/include/uapi/asm/ps3fb.h    | 3 +--
>  arch/powerpc/lib/crtsavres.S             | 5 ++---
>  arch/powerpc/xmon/ppc.h                  | 5 +++--
>  7 files changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/powerpc/boot/crtsavres.S b/arch/powerpc/boot/crtsavres.S
> index 085fb2b9a8b89..a710a49a5dbca 100644
> --- a/arch/powerpc/boot/crtsavres.S
> +++ b/arch/powerpc/boot/crtsavres.S
> @@ -26,9 +26,8 @@
>   * General Public License for more details.
>   *
>   * You should have received a copy of the GNU General Public License
> - * along with this program; see the file COPYING.  If not, write to
> - * the Free Software Foundation, 51 Franklin Street, Fifth Floor,
> - * Boston, MA 02110-1301, USA.
> + * along with this program; see the file COPYING.  If not, see
> + * <https://www.gnu.org/licenses/>.
>   *
>   *    As a special exception, if you link this library with files
>   *    compiled with GCC to produce an executable, this does not cause

Please just drop all the "boilerplate" license text from these files,
and use the proper SPDX line at the top of them instead.  That is the
overall goal for all kernel files.

thanks,

greg k-h

