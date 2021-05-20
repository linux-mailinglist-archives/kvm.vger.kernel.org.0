Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD2CE389D19
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 07:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhETF07 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 01:26:59 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59366 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbhETF06 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 01:26:58 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K5PDso037740;
        Thu, 20 May 2021 05:25:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=eFILiUcQ+qXVIacYEMB9p6Ww9HjJUgYvnlxUtiT5DOk=;
 b=cmAp4Wz0JOXvT7pi8Q+Rll7JCyNMl3HXcqB4Q7itt7BeXTZHgEAgkXdaI4qO1a8TveF2
 63wZhNrubYZ+2q4ih4qLmvuQxfFgFgZizQNhG9mqH/0+e+RkiBeSsgdgjz9dcbM+5fSq
 iGRiYRCN4/iPxKFhCR/FN/isvH/q+lApY+fHgAV9B2+uGTEtaAjXRPV8UN0ZY13e4Q6J
 B3HXv5gq6Wj7ub2DI1hJNktRzSW97mFBRcW6q/o9fso53VDAKDo8XGzBIOTPEVJ6jhq6
 gsbRw8IEVzpMTOOUTwY+ObTQJTRP9UsLQzDe6DScXAgGxeSdK9CvWWdo5X1QZE0sUzr9 iw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38j5qrbh14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:25:26 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14K5PPgr027992;
        Thu, 20 May 2021 05:25:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 38n491dk9q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:25:26 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14K5PPxo027999;
        Thu, 20 May 2021 05:25:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 38n491dk95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 May 2021 05:25:25 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 14K5PNiI020616;
        Thu, 20 May 2021 05:25:23 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 22:25:23 -0700
Date:   Thu, 20 May 2021 08:25:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        kraxel@redhat.com
Subject: Re: [PATCH -next] samples: vfio-mdev: fix error return code in
 mdpy_fb_probe()
Message-ID: <20210520052516.GA1955@kadam>
References: <20210519141559.3031063-1-weiyongjun1@huawei.com>
 <20210519094512.7ed3ea0f.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519094512.7ed3ea0f.alex.williamson@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: AUShk8Ad4OZZuMgmcBZxSOK_cS3hnaNt
X-Proofpoint-ORIG-GUID: AUShk8Ad4OZZuMgmcBZxSOK_cS3hnaNt
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9989 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105200044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021 at 09:45:12AM -0600, Alex Williamson wrote:
> On Wed, 19 May 2021 14:15:59 +0000
> Wei Yongjun <weiyongjun1@huawei.com> wrote:
> 
> > Fix to return negative error code -ENOMEM from the error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> > ---
> >  samples/vfio-mdev/mdpy-fb.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/samples/vfio-mdev/mdpy-fb.c b/samples/vfio-mdev/mdpy-fb.c
> > index 21dbf63d6e41..d4abc0594dbd 100644
> > --- a/samples/vfio-mdev/mdpy-fb.c
> > +++ b/samples/vfio-mdev/mdpy-fb.c
> > @@ -131,8 +131,10 @@ static int mdpy_fb_probe(struct pci_dev *pdev,
> >  		 width, height);
> >  
> >  	info = framebuffer_alloc(sizeof(struct mdpy_fb_par), &pdev->dev);
> > -	if (!info)
> > +	if (!info) {
> > +		ret = -ENOMEM;
> >  		goto err_release_regions;
> > +	}
> >  	pci_set_drvdata(pdev, info);
> >  	par = info->par;
> >  
> > 
> 
> I think there's also a question of why the three 'return -EINVAL;' exit
> paths between here and the prior call to pci_request_regions() don't
> also take this goto.  Thanks,
> 

Smatch catches one of these leaks...  Which is weird that it would
ignore the other error paths.  Perhaps it was intentional?

samples/vfio-mdev/mdpy-fb.c:135 mdpy_fb_probe() warn: missing error code 'ret'
samples/vfio-mdev/mdpy-fb.c:189 mdpy_fb_probe() warn: 'pdev' not released on lines: 120.

regards,
dan carpenter
