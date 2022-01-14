Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15E748EAA5
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 14:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241227AbiANN15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 08:27:57 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45934 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235222AbiANN14 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 08:27:56 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20ECvkd1029923;
        Fri, 14 Jan 2022 13:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=IfZI2zZByez3RtdCFaNBc2ezLTFV/pVvSd+PjOx06Rg=;
 b=Z7STO6zKN7q+2kJ1tZxLxqIdOsw4hwfSblyfY6XKbb6X4qiG5mxXM/JpeEOuaZkmddGs
 sosewba51G1Nxsaba8nu9C8c6zC11S05K5htG5cwNbS5bGU1/iVYTeunjTYKEOGpxmvy
 DEzgK4w4Y6uH+q8GenexaoKSFoPpTsImiUAayKBpDdz28nEebk5kPF5dIyjuzyhsEDY5
 I+A8uK4CT9Lp1dVcNCMtUiKwAo8ozuRwD3dlBHPfvs2dJrQTV07r1jRDe44umTMrU92t
 N/OI5gY2xtXgQcRfnCH3wKF/sB7ghtwhC2wUMjB3KsleGaTB6JbxQtHI77Xn1+G481Y+ Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk9n18jek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:27:56 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EDGYTS028160;
        Fri, 14 Jan 2022 13:27:55 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dk9n18jdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:27:55 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EDCtgU000882;
        Fri, 14 Jan 2022 13:27:53 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3dfwhjxv0p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 13:27:53 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EDRoVA44761566
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 13:27:50 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2B684C046;
        Fri, 14 Jan 2022 13:27:49 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3BE74C040;
        Fri, 14 Jan 2022 13:27:49 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.38.143])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 13:27:49 +0000 (GMT)
Message-ID: <b468354deac3f9902f42aa2c46e762ddf208efdd.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/5] lib: s390x: vm: Add kvm and lpar vm
 queries
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, cohuck@redhat.com
Date:   Fri, 14 Jan 2022 14:27:49 +0100
In-Reply-To: <20220114100245.8643-2-frankja@linux.ibm.com>
References: <20220114100245.8643-1-frankja@linux.ibm.com>
         <20220114100245.8643-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oeVA27Q_4NKz0OT2fx_-YGwe_0RMPZ4N
X-Proofpoint-GUID: 27rn2zWMTMn7EN8RZaODCaUmD0KK2P_O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_04,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0
 mlxlogscore=999 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-01-14 at 10:02 +0000, Janosch Frank wrote:
> This patch will likely (in parts) be replaced by Pierre's patch from
> his topology test series.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/vm.c | 39 +++++++++++++++++++++++++++++++++++++++
>  lib/s390x/vm.h | 23 +++++++++++++++++++++++
>  s390x/stsi.c   | 21 +--------------------
>  3 files changed, 63 insertions(+), 20 deletions(-)
> 
> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> index a5b92863..266a81c1 100644
> --- a/lib/s390x/vm.c
> +++ b/lib/s390x/vm.c
> @@ -26,6 +26,11 @@ bool vm_is_tcg(void)
>         if (initialized)
>                 return is_tcg;
>  
> +       if (stsi_get_fc() < 3) {
> +               initialized = true;
> +               return false;

Minor nit: By setting initialized to true, you rely on the previous
initialization of is_tcg to false for subsequent calls.

You could make this more obvious by saying:

return is_tcg;
