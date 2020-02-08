Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF24156232
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2020 02:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgBHBID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 20:08:03 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58580 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbgBHBID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 20:08:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01814AB8177285;
        Sat, 8 Feb 2020 01:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DfrmC4Z3jp+mcIzm8JLNJvTgLgw18atInL0rLuWEGyI=;
 b=Q6JAavaaDJyOiiuy9rQfOS5EyGWmGIiMitvNQhGOiYZo26lvW6nahkiKE+Eq7rTmK5BB
 dtgNTD59gAmr4FrPuuBwB6DYBkWTFIJe7h1DzmEglFdIPkL2D6QqvqJDEG7f3+WhNgZY
 ejp8mMHqrqs8eyaLs8k6oVX0DGPbNNDNeUbP3KM2kp4hd2Gquy3tKTG0EYVlK7dhmWFe
 +r+DlD2sJFeg3cBtuDLQI6Gu/YD8geXRd9YMyd/3vxCqISDDrh7GKokQajsFZQac2OQQ
 KiMFr5FxdBBXR5cmp5ueyesitP1EZwzHDVRRUAgMgk0GXSRIckwWbZH8916eVJNvNFsB zQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2xykbpk3pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Feb 2020 01:07:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 01814NAU167750;
        Sat, 8 Feb 2020 01:07:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2y1j4nbagt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 Feb 2020 01:07:55 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01817rZC032342;
        Sat, 8 Feb 2020 01:07:53 GMT
Received: from localhost.localdomain (/10.159.239.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Feb 2020 17:07:53 -0800
Subject: Re: [PATCH v5 2/4] selftests: KVM: Remove unused x86_register enum
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com
Cc:     thuth@redhat.com, drjones@redhat.com, wei.huang2@amd.com
References: <20200207142715.6166-1-eric.auger@redhat.com>
 <20200207142715.6166-3-eric.auger@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <cc575b88-14f4-e2ee-9d91-9f5d2e06684b@oracle.com>
Date:   Fri, 7 Feb 2020 17:07:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20200207142715.6166-3-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9524 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2002080006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9524 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2002080006
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2/7/20 6:27 AM, Eric Auger wrote:
> x86_register enum is not used. Its presence incites us
> to enumerate GPRs in the same order in other looming
> structs. So let's remove it.
>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>   .../selftests/kvm/include/x86_64/processor.h  | 20 -------------------
>   1 file changed, 20 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> index 6f7fffaea2e8..e48dac5c29e8 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> @@ -36,26 +36,6 @@
>   #define X86_CR4_SMAP		(1ul << 21)
>   #define X86_CR4_PKE		(1ul << 22)
>   
> -/* The enum values match the intruction encoding of each register */
> -enum x86_register {
> -	RAX = 0,
> -	RCX,
> -	RDX,
> -	RBX,
> -	RSP,
> -	RBP,
> -	RSI,
> -	RDI,
> -	R8,
> -	R9,
> -	R10,
> -	R11,
> -	R12,
> -	R13,
> -	R14,
> -	R15,
> -};
> -
>   struct desc64 {
>   	uint16_t limit0;
>   	uint16_t base0;
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
