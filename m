Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3671AE254
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726022AbgDQQdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 12:33:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:23458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725877AbgDQQdW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 12:33:22 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03HGVmZJ096168;
        Fri, 17 Apr 2020 12:33:21 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ff1u21fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 12:33:21 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03HGWY5T101876;
        Fri, 17 Apr 2020 12:33:21 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ff1u21ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 12:33:21 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03HGWUeL032582;
        Fri, 17 Apr 2020 16:33:19 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04wdc.us.ibm.com with ESMTP id 30b5h7bm5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Apr 2020 16:33:19 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03HGXJOY47972690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 16:33:19 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5DEA2124055;
        Fri, 17 Apr 2020 16:33:19 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2DF2124054;
        Fri, 17 Apr 2020 16:33:18 +0000 (GMT)
Received: from [9.160.33.156] (unknown [9.160.33.156])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 16:33:18 +0000 (GMT)
Subject: Re: [PATCH] vfio-ccw: document possible errors
To:     Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20200407111605.1795-1-cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Message-ID: <55932365-3d36-1629-5d65-06c71e8231f9@linux.ibm.com>
Date:   Fri, 17 Apr 2020 12:33:18 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200407111605.1795-1-cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_07:2020-04-17,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170128
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/7/20 7:16 AM, Cornelia Huck wrote:
> Interacting with the I/O and the async regions can yield a number
> of errors, which had been undocumented so far. These are part of
> the api, so remedy that.

(Makes a note to myself, to do the same for the schib/crw regions we're
adding for channel path handling.)

> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  Documentation/s390/vfio-ccw.rst | 54 ++++++++++++++++++++++++++++++++-
>  1 file changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
> index fca9c4f5bd9c..4538215a362c 100644
> --- a/Documentation/s390/vfio-ccw.rst
> +++ b/Documentation/s390/vfio-ccw.rst
> @@ -210,7 +210,36 @@ Subchannel.
>  
>  irb_area stores the I/O result.
>  
> -ret_code stores a return code for each access of the region.
> +ret_code stores a return code for each access of the region. The following
> +values may occur:
> +
> +``0``
> +  The operation was successful.
> +
> +``-EOPNOTSUPP``
> +  The orb specified transport mode or an unidentified IDAW format, did not
> +  specify prefetch mode, or the scsw specified a function other than the
> +  start function.
> +
> +``-EIO``
> +  A request was issued while the device was not in a state ready to accept
> +  requests, or an internal error occurred.
> +
> +``-EBUSY``
> +  The subchannel was status pending or busy, or a request is already active.
> +
> +``-EAGAIN``
> +  A request was being processed, and the caller should retry.
> +
> +``-EACCES``
> +  The channel path(s) used for the I/O were found to be not operational.
> +
> +``-ENODEV``
> +  The device was found to be not operational.
> +
> +``-EINVAL``
> +  The orb specified a chain longer than 255 ccws, or an internal error
> +  occurred.
>  
>  This region is always available.

Maybe move this little line up between the struct layout and "While
starting an I/O request, orb_area ..." instead of being lost way down here?

But other than that suggestion, everything looks fine.

Reviewed-by: Eric Farman <farman@linux.ibm.com>

>  
> @@ -231,6 +260,29 @@ This region is exposed via region type VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD.
>  
>  Currently, CLEAR SUBCHANNEL and HALT SUBCHANNEL use this region.
>  
> +command specifies the command to be issued; ret_code stores a return code
> +for each access of the region. The following values may occur:
> +
> +``0``
> +  The operation was successful.
> +
> +``-ENODEV``
> +  The device was found to be not operational.
> +
> +``-EINVAL``
> +  A command other than halt or clear was specified.
> +
> +``-EIO``
> +  A request was issued while the device was not in a state ready to accept
> +  requests.
> +
> +``-EAGAIN``
> +  A request was being processed, and the caller should retry.
> +
> +``-EBUSY``
> +  The subchannel was status pending or busy while processing a halt request.
> +
> +
>  vfio-ccw operation details
>  --------------------------
>  
> 
