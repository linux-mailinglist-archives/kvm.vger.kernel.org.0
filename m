Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7AB131F98
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 06:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbgAGFvo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 00:51:44 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:50062 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgAGFvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 00:51:43 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0075oWqQ138231;
        Tue, 7 Jan 2020 05:51:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=FX1w0gnaqOtHVlLB12KUrqDVgRh7RKvu7wXTN3xpWIs=;
 b=VikCSRTC7gD7hAyIiLEqBoe6ga15HhXlnAKDOHSlfNl2YiUbKD1NoZzpPi39PCZLT5Fn
 vL9owj0PTd7R45oEwAksU+P+GWGhH3BxcU/ldQvoelDoTh5iNMgEofi8+pS4YvIgKYM0
 E2/R4RqdLMxTkooSzj6VeLQp1anV4xMZyLS6PlGMS2zqbId9YFxcJ930dMPn015e0/gT
 LTF3Yd+fkRLljhE048kEcRI70CjAdUpMVHYW2gIejYQAoa1VL5Lf59/+5Uf3USz3Z6w4
 8xc8Ftn0fHiDxj9MfhGOrE+CEAbHWugCoOU+CsI9JArzveYBKDz5h2qWXIql3BrGCpFJ NA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2xakbqk3nw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 05:51:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0075oSAv060346;
        Tue, 7 Jan 2020 05:51:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2xcjvcc1hs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Jan 2020 05:51:34 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0075pXc3009766;
        Tue, 7 Jan 2020 05:51:33 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 06 Jan 2020 21:51:33 -0800
Date:   Tue, 7 Jan 2020 08:51:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Julia Lawall <Julia.Lawall@inria.fr>,
        kernel-janitors@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] vfio: vfio_pci_nvlink2: use mmgrab
Message-ID: <20200107055126.GM3911@kadam>
References: <1577634178-22530-1-git-send-email-Julia.Lawall@inria.fr>
 <1577634178-22530-3-git-send-email-Julia.Lawall@inria.fr>
 <20200106160505.2f962d38@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106160505.2f962d38@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001070046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9492 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001070046
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 04:05:05PM -0700, Alex Williamson wrote:
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Thanks!  I'm assuming these will be routed via janitors tree, please
> let me know if you intend me to grab these two vfio patches from the
> series.  Thanks,

There isn't a janitors tree.

regards,
dan carpenter

