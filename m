Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE2366D85E4
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjDESXc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbjDESXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:23:31 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942EF3C38
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 11:23:30 -0700 (PDT)
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335HMWb7029593;
        Wed, 5 Apr 2023 18:23:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=qcppdkim1;
 bh=ATuS4Wftab2uHxmwIshAh84WAJ0uXVGyPcyRjldcboo=;
 b=i6lWLFi4Gq1X4Nr9MLBXfOHS4Whp+F9J8BVN9hZJczhWKIB2+DZnT4bim6bQ+E12/0AZ
 iKHoqeSkKVemF+vmW7fhej+3kWZdpTWbqMBJZqHolJA/EiHpHtWHsG1+hMXvSmb/BKRU
 6dH3Ev1WdOdi8cy7bzfSkj57Csz67umWQZsNEEBjxpc32Z64fn805V+PgevsVnJS40Dr
 bKp6iaCkTk+kUCKO4/GEfc++Z0XtxhCyR4KHP/lbusYoH/c6N2dPR0yFBv46X5ZfmQT5
 NnFVkslyIq8eaFUv0kur2eu2FlnBkQ6BYMEtKH7eWtbnthEXI7Z1L2hEgYeLc8Hadf5l YQ== 
Received: from nasanppmta03.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ps8h08v3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 05 Apr 2023 18:23:21 +0000
Received: from nasanex01c.na.qualcomm.com (nasanex01c.na.qualcomm.com [10.45.79.139])
        by NASANPPMTA03.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 335INKRL014706
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Apr 2023 18:23:20 GMT
Received: from qc-i7.hemma.eciton.net (10.80.80.8) by
 nasanex01c.na.qualcomm.com (10.45.79.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.42; Wed, 5 Apr 2023 11:23:17 -0700
Date:   Wed, 5 Apr 2023 19:23:14 +0100
From:   Leif Lindholm <quic_llindhol@quicinc.com>
To:     Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
CC:     <qemu-devel@nongnu.org>, <qemu-s390x@nongnu.org>,
        <qemu-riscv@nongnu.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        <qemu-arm@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-ppc@nongnu.org>, Radoslaw Biernacki <rad@semihalf.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 05/10] hw/arm/sbsa-ref: Include missing 'sysemu/kvm.h'
 header
Message-ID: <ZC28khr/jGDKK4/W@qc-i7.hemma.eciton.net>
References: <20230405160454.97436-1-philmd@linaro.org>
 <20230405160454.97436-6-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230405160454.97436-6-philmd@linaro.org>
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nasanex01c.na.qualcomm.com (10.45.79.139)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: yuK9uBlDPdNsmZVYPiBTy9iMpffC3DO4
X-Proofpoint-ORIG-GUID: yuK9uBlDPdNsmZVYPiBTy9iMpffC3DO4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_12,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=789 phishscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050164
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 18:04:49 +0200, Philippe Mathieu-Daudé wrote:
> "sysemu/kvm.h" is indirectly pulled in. Explicit its
> inclusion to avoid when refactoring include/:
> 
>   hw/arm/sbsa-ref.c:693:9: error: implicit declaration of function 'kvm_enabled' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
>     if (kvm_enabled()) {
>         ^
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  hw/arm/sbsa-ref.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
> index 0b93558dde..7df4d7b712 100644
> --- a/hw/arm/sbsa-ref.c
> +++ b/hw/arm/sbsa-ref.c
> @@ -26,6 +26,7 @@
>  #include "sysemu/numa.h"
>  #include "sysemu/runstate.h"
>  #include "sysemu/sysemu.h"
> +#include "sysemu/kvm.h"

Can I do my traditional nitpick and ask this to be added above
sysemu/numa.h in order to maintain alphabetical ordering within the
sysemu block?

With that:
Reviewed-by: Leif Lindholm <quic_llindhol@quicinc.com>


>  #include "exec/hwaddr.h"
>  #include "kvm_arm.h"
>  #include "hw/arm/boot.h"
> -- 
> 2.38.1
> 
