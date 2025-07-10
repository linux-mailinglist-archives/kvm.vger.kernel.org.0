Return-Path: <kvm+bounces-52051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6529DB00A0C
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 19:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AA4A31889543
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 17:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A802F0C7D;
	Thu, 10 Jul 2025 17:39:59 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC9BD12B71;
	Thu, 10 Jul 2025 17:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.228.1.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752169198; cv=none; b=gywaG/irCr++GVtMe5wdQ/MefCmPpC3WytXwc0y5E1/tDW7UVEGqNMyE1oNhkCAMhbWYwIMmGO0VK130s8TGrQJ+yh1TCLp3YFN/e6IkKcDw/ISPjR/9NgjbkRcXaAxRJ3y9znNl6QcsrWnq7CNrUIoAyvwXRJae1kicpirRC8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752169198; c=relaxed/simple;
	bh=RSxWcKNTwFXrVX5CebJk5177Z4CdLNW1KEpXWN+IGhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcO4krrsC81kNFSn+K13OQRLKuNojyYh+ZCcX5hIAk2hnA6PH0382jLbUEOAFHvSgcQpxI23O4rt1+JFwLQWkmuSxfL9eFY86HhBpEh40OuBeWbngJ1q33vb5XU3oydKjYvLleXkpqXs06FTjvpi7doadX+4izapa2Ed3PROWR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org; spf=pass smtp.mailfrom=kernel.crashing.org; arc=none smtp.client-ip=63.228.1.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.crashing.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.crashing.org
Received: from gate.crashing.org (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 56AHdJKS508082;
	Thu, 10 Jul 2025 12:39:19 -0500
Received: (from segher@localhost)
	by gate.crashing.org (8.18.1/8.18.1/Submit) id 56AHdDIB508074;
	Thu, 10 Jul 2025 12:39:13 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Thu, 10 Jul 2025 12:39:13 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] powerpc: Replace the obsolete address of the FSF
Message-ID: <aG_6wcivy5-0oiyB@gate>
References: <20250710121657.169969-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250710121657.169969-1-thuth@redhat.com>

On Thu, Jul 10, 2025 at 02:16:57PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> The FSF does not reside in the Franklin street anymore. Let's update
> the address with the link to their website, as suggested in the latest
> revision of the GPL-2.0 license.
> (See https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt for example)

That looks good, this is indeed the newer GPLv2 text.

Acked-by: Segher Boessenkool <segher@kernel.crashing.org>

> diff --git a/arch/powerpc/boot/crtsavres.S b/arch/powerpc/boot/crtsavres.S
Segher


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
> diff --git a/arch/powerpc/include/uapi/asm/eeh.h b/arch/powerpc/include/uapi/asm/eeh.h
> index 28186071fafc4..4a117cc475299 100644
> --- a/arch/powerpc/include/uapi/asm/eeh.h
> +++ b/arch/powerpc/include/uapi/asm/eeh.h
> @@ -9,9 +9,8 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   * GNU General Public License for more details.
>   *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <https://www.gnu.org/licenses/>.
>   *
>   * Copyright IBM Corp. 2015
>   *
> diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
> index eaeda001784eb..75c1d7a48ad52 100644
> --- a/arch/powerpc/include/uapi/asm/kvm.h
> +++ b/arch/powerpc/include/uapi/asm/kvm.h
> @@ -9,9 +9,8 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   * GNU General Public License for more details.
>   *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <https://www.gnu.org/licenses/>.
>   *
>   * Copyright IBM Corp. 2007
>   *
> diff --git a/arch/powerpc/include/uapi/asm/kvm_para.h b/arch/powerpc/include/uapi/asm/kvm_para.h
> index a809b1b44ddfe..66d1e17e427a6 100644
> --- a/arch/powerpc/include/uapi/asm/kvm_para.h
> +++ b/arch/powerpc/include/uapi/asm/kvm_para.h
> @@ -9,9 +9,8 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   * GNU General Public License for more details.
>   *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, see <https://www.gnu.org/licenses/>.
>   *
>   * Copyright IBM Corp. 2008
>   *
> diff --git a/arch/powerpc/include/uapi/asm/ps3fb.h b/arch/powerpc/include/uapi/asm/ps3fb.h
> index fd7e3a0d35d57..af6322042b3b0 100644
> --- a/arch/powerpc/include/uapi/asm/ps3fb.h
> +++ b/arch/powerpc/include/uapi/asm/ps3fb.h
> @@ -13,8 +13,7 @@
>   * General Public License for more details.
>   *
>   * You should have received a copy of the GNU General Public License along
> - * with this program; if not, write to the Free Software Foundation, Inc.,
> - * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + * with this program; if not, see <https://www.gnu.org/licenses/>.
>   */
>  
>  #ifndef _ASM_POWERPC_PS3FB_H_
> diff --git a/arch/powerpc/lib/crtsavres.S b/arch/powerpc/lib/crtsavres.S
> index 8967903c15e99..c7e58b6614169 100644
> --- a/arch/powerpc/lib/crtsavres.S
> +++ b/arch/powerpc/lib/crtsavres.S
> @@ -27,9 +27,8 @@
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
> diff --git a/arch/powerpc/xmon/ppc.h b/arch/powerpc/xmon/ppc.h
> index 1d98b8dd134ef..270097f6e905b 100644
> --- a/arch/powerpc/xmon/ppc.h
> +++ b/arch/powerpc/xmon/ppc.h
> @@ -15,8 +15,9 @@ warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
>  the GNU General Public License for more details.
>  
>  You should have received a copy of the GNU General Public License
> -along with this file; see the file COPYING.  If not, write to the Free
> -Software Foundation, 51 Franklin Street - Fifth Floor, Boston, MA 02110-1301, USA.  */
> +along with this file; see the file COPYING.  If not, see
> +<https://www.gnu.org/licenses/>.
> +*/
>  
>  #ifndef PPC_H
>  #define PPC_H
> -- 
> 2.50.0
> 

