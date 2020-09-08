Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C933260C86
	for <lists+kvm@lfdr.de>; Tue,  8 Sep 2020 09:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729710AbgIHHxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Sep 2020 03:53:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729626AbgIHHxq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 8 Sep 2020 03:53:46 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0887rfFr073852;
        Tue, 8 Sep 2020 03:53:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=d9RMGZDmfHgM/BD5rpejcQSPuz5K4nYSs1jtOoSkpEw=;
 b=shz4uoAkUIY2tZwQWxI501Mig+6Mxdi9X1i/Zdsl2I54VK90qsbrwC1H4Bdg9gFYr5hK
 DrBANqm8OlMp+KK93MDBygs6wDbL29Wc1+4pWj+djFjOUqaClbwWy856pPlSG32OrAqy
 BOOGEAXTwnxqctx8oBXiqVEP647EvvDDmgG3AfoY/AUSCybgt1jtYgT9zu3DEIKIScNo
 YK7y3eVLoQBLkDyl2wCIVqRT1kBObh53FdeQMcywYd7HtLG74Lh1ZLWuF/IcFN1bxn1q
 HANUNVaO8ed+oMG+xlCwG/GSnD7lrTa8A+KhNihJcf86TsJux8U12s2v7n8ZtOXQjXFH OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e5ye802v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 03:53:44 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0887rhkc073962;
        Tue, 8 Sep 2020 03:53:43 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33e5ye802c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 03:53:43 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0887pvDM012554;
        Tue, 8 Sep 2020 07:53:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 33dxdr0bhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Sep 2020 07:53:41 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0887rd7431588790
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Sep 2020 07:53:39 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 190AF4204F;
        Tue,  8 Sep 2020 07:53:39 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF2EB42042;
        Tue,  8 Sep 2020 07:53:38 +0000 (GMT)
Received: from osiris (unknown [9.171.47.162])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  8 Sep 2020 07:53:38 +0000 (GMT)
Date:   Tue, 8 Sep 2020 09:53:37 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, kbuild-all@lists.01.org,
        borntraeger@de.ibm.com, gor@linux.ibm.com, imbrenda@linux.ibm.com,
        kvm@vger.kernel.org, david@redhat.com
Subject: Re: [PATCH v2 2/2] s390x: Add 3f program exception handler
Message-ID: <20200908075337.GA9170@osiris>
References: <20200907124700.10374-3-frankja@linux.ibm.com>
 <202009080542.UHmgfE5u%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009080542.UHmgfE5u%lkp@intel.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-08_03:2020-09-08,2020-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 phishscore=0 mlxlogscore=803
 malwarescore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009080066
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Janosch,

On Tue, Sep 08, 2020 at 05:56:19AM +0800, kernel test robot wrote:
> All warnings (new ones prefixed by >>):
> 
> >> arch/s390/mm/fault.c:862:6: warning: no previous prototype for 'do_secure_storage_violation' [-Wmissing-prototypes]
>      862 | void do_secure_storage_violation(struct pt_regs *regs)
>          |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> # https://github.com/0day-ci/linux/commit/4aee662164217d48d050e0d9cf57a2cb2cdeaa8a
> git remote add linux-review https://github.com/0day-ci/linux
> git fetch --no-tags linux-review Janosch-Frank/s390x-pv-Fixes-and-improvements/20200908-021233
> git checkout 4aee662164217d48d050e0d9cf57a2cb2cdeaa8a
> vim +/do_secure_storage_violation +862 arch/s390/mm/fault.c
> 
>    861	
>  > 862	void do_secure_storage_violation(struct pt_regs *regs)

To get rid of this warning, please add the function prototype to
arch/s390/kernel/entry.h. Like we have them for all other program
check handlers for this reason as well.
