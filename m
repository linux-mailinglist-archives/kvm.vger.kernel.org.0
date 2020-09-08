Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0732261DAD
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 21:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730857AbgIHTkk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 15:40:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48966 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730926AbgIHPyo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 11:54:44 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 088D3sGs029141;
        Tue, 8 Sep 2020 09:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Uf7NA+qsrxr1sCfRA5qiW8nYuxaWjlzAUVC3yoI7yWA=;
 b=bN4RSvPSfc+bmcreACzbdysoyH7t0s+av0tG2zfh/OPTifvcew5LKzAiq1zbXanerpF3
 u7dgyCJ0EwNu15FzQliYjcV2YGDLjoTflqzlm47YzQbBoNTJu1lJuxX8Y3vfa58bZU/O
 nPVX3dEXDIhpdTkiYu6TLN++AW+IeLJE0edz3uLxxSByVLwFbEAVtBNHee8IQl9UBrRm
 iUA217ED0b7gsymGq5E44fIdfGbDemdnYW9G5OlmKVwMN5lGTfwC+On9wCeB9xt576Jf
 ZDluu/AfU0U/aEbiGIjrfGaAEhUotUsedJRJ5lCve0eMWX0vkn4rsRwokysozw/lIXHA ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e9scsv08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 09:07:03 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 088D3vDv029273;
        Tue, 8 Sep 2020 09:07:02 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33e9scsuy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 09:07:02 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 088D70dP010285;
        Tue, 8 Sep 2020 13:07:00 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 33c2a824ew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 13:07:00 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 088D6vnH32375210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 13:06:57 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5825FA4057;
        Tue,  8 Sep 2020 13:06:57 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA691A4040;
        Tue,  8 Sep 2020 13:06:56 +0000 (GMT)
Received: from osiris (unknown [9.171.47.162])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Sep 2020 13:06:56 +0000 (GMT)
Date:   Tue, 8 Sep 2020 15:06:55 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, borntraeger@de.ibm.com,
        gor@linux.ibm.com, imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com, thuth@redhat.com
Subject: Re: [PATCH v3] s390x: Add 3f program exception handler
Message-ID: <20200908130655.GF14136@osiris>
References: <20200908075337.GA9170@osiris>
 <20200908130504.24641-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908130504.24641-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_06:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=1 clxscore=1015 adultscore=0
 malwarescore=0 spamscore=0 mlxscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 08, 2020 at 09:05:04AM -0400, Janosch Frank wrote:
> Program exception 3f (secure storage violation) can only be detected
> when the CPU is running in SIE with a format 4 state description,
> e.g. running a protected guest. Because of this and because user
> space partly controls the guest memory mapping and can trigger this
> exception, we want to send a SIGSEGV to the process running the guest
> and not panic the kernel.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> CC: <stable@vger.kernel.org> # 5.7+
> Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
> ---
>  arch/s390/kernel/entry.h     |  1 +
>  arch/s390/kernel/pgm_check.S |  2 +-
>  arch/s390/mm/fault.c         | 20 ++++++++++++++++++++
>  3 files changed, 22 insertions(+), 1 deletion(-)

I guess this should go upstream via the s390 tree?
Should I pick this up?
