Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF0C3755E2
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 16:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234836AbhEFOsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 10:48:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58896 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234932AbhEFOr6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 10:47:58 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 146EYYBK127504;
        Thu, 6 May 2021 10:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=tXoCNIlB2bctjjVycl7DyvYGC6RmCOECwtOCPYo4JEs=;
 b=lRxXP46j6s6T/HZ3GoKTUGAXnNIiM//MfjFwhUBJ7I51Ud0986zrCSuA0ax1mj4+vJ5+
 OI+f5FsDSVpQVqlEdT5m7HwNu2THZugwx+wt6Avx0Z5XwIu38NIi/QWz5TIJktN8AOJo
 6a+HNaa276nM31CPHiI1rnBTnMKwqM/QHtnQoohc1Ujzwa6gULRvgyOAoeRx7y7CIMgk
 SdtRTHbvol2nC8JdBCsBYP894c+cPpex89qZZ6Rzu2/oUvMvnxplmIk92wGcHJAwqHU2
 EtJMtaELA6xqmsRT6ZOeMHdmpcas/huRAhxtnganPJkuQrh5Bj8AVq/NEyMg/iFI/J9K gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38cjb9gd7t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 May 2021 10:46:51 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 146Ek8VA191550;
        Thu, 6 May 2021 10:46:51 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38cjb9gd7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 May 2021 10:46:51 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 146EgdiR004612;
        Thu, 6 May 2021 14:46:50 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03dal.us.ibm.com with ESMTP id 38bee8qg9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 May 2021 14:46:50 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 146EknUp28705050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 May 2021 14:46:49 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1BB7ABE05A;
        Thu,  6 May 2021 14:46:49 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F36FBE053;
        Thu,  6 May 2021 14:46:48 +0000 (GMT)
Received: from [9.47.158.152] (unknown [9.47.158.152])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  6 May 2021 14:46:48 +0000 (GMT)
Subject: Re: [PATCH v2 3/9] backends/tpm: Replace g_alloca() by g_malloc()
To:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
 <20210506133758.1749233-4-philmd@redhat.com>
From:   Stefan Berger <stefanb@linux.ibm.com>
Message-ID: <bf880c36-2b09-602f-aea0-772949c55ed5@linux.ibm.com>
Date:   Thu, 6 May 2021 10:46:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210506133758.1749233-4-philmd@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: C1U5KbtyB40mvw-9k_VQmXxEV4-YhsIA
X-Proofpoint-GUID: yJl_b3BVn1FBli3v8yQBZL7VE7WfBgOj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-06_10:2021-05-06,2021-05-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 clxscore=1015 mlxscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105060106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/6/21 9:37 AM, Philippe Mathieu-Daudé wrote:
> The ALLOCA(3) man-page mentions its "use is discouraged".
>
> Replace a g_alloca() call by a g_malloc() one, moving the
> allocation before the MUTEX guarded block.
>
> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
